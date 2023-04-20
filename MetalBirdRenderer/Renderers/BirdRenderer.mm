//
//  BirdRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/BirdRenderer.hpp>

constinit const std::float_t BirdRenderer::angle (0.f);

BirdRenderer::BirdRenderer(
                           MTKView *mtkView,
                           id<MTLDevice> device,
                           id<MTLLibrary> library,
                           NSError * _Nullable __autoreleasing * error
                           ) : BaseRenderer(mtkView, device, library, error)
{
    MTLFunctionDescriptor *vertexFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    vertexFunctionDescriptor.name = @"bird::vertex_main";
    
    id<MTLFunction> vertexFunction = [library newFunctionWithDescriptor:vertexFunctionDescriptor error:error];
    if (*error) return;
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"bird::fragment_main";
    
    id<MTLFunction> fragmentFunction = [library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) return;
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    /* TODO */
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    
    this->pipelineState = pipelineState;
}

void BirdRenderer::mtkView_drawableSizeWillChange(MTKView *mtkView, struct CGSize size) {
    BaseRenderer::mtkView_drawableSizeWillChange(mtkView, size);
}

void BirdRenderer::drawInMTKView(MTKView *mtkView) {
    BaseRenderer::drawInMTKView(mtkView);
    
    
}
