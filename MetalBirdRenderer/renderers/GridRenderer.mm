//
//  GridRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/GridRenderer.hpp>

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
    if (*error) {
        return;
    }
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"grid::fragment_main";
    id<MTLFunction> fragmentFunction = [library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) {
        return;
    }
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(simd_float3);
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    std::array<simd_float2, GRID_RENDERER_COUNT> coords = this->makeCoords();
    std::array<simd_float2, GRID_RENDERER_COUNT> indices = this->makeIndices();
    
    id<MTLBuffer> coordsBuffer = [device newBufferWithBytes:<#(nonnull const void *)#> length:<#(NSUInteger)#> options:<#(MTLResourceOptions)#>]
    
    this->pipelineState = pipelineState;
    this->coords = this->makeCoords();
    this->indices = this->makeIndices();
}

void GridRenderer::renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size) {
    BaseRenderer::renderWithEncoder(encoder, size);
    
    [encoder setRenderPipelineState:this->pipelineState];
    
    [encoder setVertexBuffer:self.coordsBuffer offset:0 atIndex:0];
    
    for (NSUInteger i = 0; i < (GRID_BLOCK_COUNT - 1) * 2; i++) {
        @autoreleasepool {
            [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                                      indexCount:2
                                       indexType:MTLIndexTypeUInt16
                                     indexBuffer:self.indicesBuffer
                               indexBufferOffset:sizeof(ushort) * i * 2];
        }
    }
    
    //
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = [view currentDrawable];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

std::array<simd_float2, GRID_RENDERER_COUNT> GridRenderer::makeCoords() {
    std::array<simd_float2, GRID_RENDERER_COUNT> results {};
    
    for (ushort i = 0; i < GRID_RENDERER_COUNT / 2; i = i + 2) {
        float coord = -1.f + static_cast<float>(i + 2);
        
        results.at(i) = simd_make_float2(-1.f, coord);
        results.at(i + 1) = simd_make_float2(1.f, coord);
        results.at(i + GRID_RENDERER_COUNT / 2) = simd_make_float2(coord, -1.f);
        results.at(i + GRID_RENDERER_COUNT / 2 + 1) = simd_make_float2(coord, 1.f);
    }
    
    return results;
}

std::array<simd_float2, GRID_RENDERER_COUNT> GridRenderer::makeIndices() {
    std::array<simd_float2, GRID_RENDERER_COUNT> results {};
    
    for (ushort i = 0; i < GRID_RENDERER_COUNT; i++) {
        results.at(i) = i;
    }
    
    return results;
}
