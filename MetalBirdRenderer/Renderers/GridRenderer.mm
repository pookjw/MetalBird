//
//  GridRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/GridRenderer.hpp>
#import <cmath>
#import <ranges>
#import <algorithm>

constinit const std::int16_t GridRenderer::length = GRID_RENDERER_LENGTH;

constexpr const std::int16_t GridRenderer::count() {
    // Not implemented in clang yet.
//    return std::fmal(GridRenderer::length, 4, -4);
    return GRID_RENDERER_COUNT;
}

GridRenderer::GridRenderer(
                           MTKView *mtkView,
                           id<MTLDevice> device,
                           id<MTLLibrary> library,
                           NSError * _Nullable __autoreleasing * error
                           ) : BaseRenderer(mtkView, device, library, error)
{
    MTLFunctionDescriptor *vertexFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    vertexFunctionDescriptor.name = @"grid::vertex_main";
    
    id<MTLFunction> vertexFunction = [library newFunctionWithDescriptor:vertexFunctionDescriptor error:error];
    if (*error) return;
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"grid::fragment_main";
    id<MTLFunction> fragmentFunction = [library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) return;
    
    std::array<simd_float2, GridRenderer::count()> coords = this->makeCoords();
    std::array<ushort, GridRenderer::count()> indices = this->makeIndices();
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(std::tuple_element<0, decltype(coords)>::type);
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    
    id<MTLBuffer> coordsBuffer = [device newBufferWithBytes:coords.data() length:coords.max_size() * sizeof(std::tuple_element<0, decltype(coords)>::type) options:0];
    id<MTLBuffer> indicesBuffer = [device newBufferWithBytes:indices.data() length:indices.max_size() * sizeof(std::tuple_element<0, decltype(indices)>::type) options:0];
    
    this->pipelineState = pipelineState;
    this->coords = coords;
    this->indices = indices;
    this->coordsBuffer = coordsBuffer;
    this->indicesBuffer = indicesBuffer;
}

void GridRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    [renderEncoder setRenderPipelineState:this->pipelineState];
    
    [renderEncoder setVertexBuffer:this->coordsBuffer offset:0 atIndex:0];
    
    for (std::int16_t i = 0; std::cmp_less(i, std::div(GridRenderer::count(), 2).quot); i++) {
        @autoreleasepool {
            [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                                indexCount:2
                                 indexType:MTLIndexTypeUInt16
                               indexBuffer:this->indicesBuffer
                         indexBufferOffset:sizeof(std::tuple_element<0, decltype(this->indices)>::type) * i * 2];
        }
    }
}

std::array<simd_float2, GRID_RENDERER_COUNT> GridRenderer::makeCoords() {
    std::array<simd_float2, GridRenderer::count()> results {};
    
    std::float_t unit = std::powf(GridRenderer::length, -1.f);
    
    for (std::int16_t i = 0; std::cmp_less(i, std::div(GridRenderer::count(), 2).quot); i = i + 2) {
        std::float_t coord = std::fmaf(unit, static_cast<std::float_t>(i + 2), -1.f);
        
        results.at(i) = simd_make_float2(-1.f, coord);
        results.at(i + 1) = simd_make_float2(1.f, coord);
        results.at(i + std::div(GridRenderer::count(), 2).quot) = simd_make_float2(coord, -1.f);
        results.at(i + std::div(GridRenderer::count(), 2).quot + 1) = simd_make_float2(coord, 1.f);
    }
    
    return results;
}

std::array<std::uint16_t, GRID_RENDERER_COUNT> GridRenderer::makeIndices() {
    std::array<std::uint16_t, GridRenderer::count()> results {};
    
    std::uint16_t value = 0;
    std::generate(results.begin(), results.end(), [&value]() {
        return value++;
    });
    
//    std::for_each(results.begin(), results.end(), [&results](std::uint16_t &value) {
//        std::uint16_t index = &value - results.data();
//        results.at(index) = index;
//    });
    
    return results;
}
