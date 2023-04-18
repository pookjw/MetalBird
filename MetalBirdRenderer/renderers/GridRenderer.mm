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
    
    this->pipelineState = pipelineState;
}

void GridRenderer::renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size) {
    BaseRenderer::renderWithEncoder(encoder, size);
    this->coords();
}

std::array<simd_float2, GRID_RENDERER_COUNT> GridRenderer::coords() {
    std::array<simd_float2, GRID_RENDERER_COUNT> results {};
    
    for (short i = 0; i < (GRID_RENDERER_COUNT - 1) * 2; i = i + 2) {
        float coord = -1.f + static_cast<float>(i + 2);
        
        results[i] = simd_make_float2(-1.f, coord);
    }
    
    return results;
}
