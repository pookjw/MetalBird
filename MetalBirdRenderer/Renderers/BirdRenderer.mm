//
//  BirdRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/BirdRenderer.hpp>
#import <iostream>

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

void BirdRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, std::optional<struct CGSize> size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    [renderEncoder setRenderPipelineState:this->pipelineState];
    
//    if (this->readyToJump.load()) {
//        this->timer += 0.5;
//        this->readyToJump.store(false);
//    }
    if (this->increasing) {
        this->timer += 0.007f;
        if (this->timer >= 0.7f) {
            this->increasing = false;
        }
    } else {
        this->timer -= 0.007f;
        if (this->timer <= -0.7f) {
            this->increasing = true;
        }
    }
    
    id<MTLBuffer> timerBuffer = [this->device newBufferWithBytes:&this->timer length:sizeof(std::float_t) options:0];
    
    [renderEncoder setVertexBuffer:timerBuffer offset:0 atIndex:0];
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypePoint
                      vertexStart:0
                      vertexCount:1];
}

void BirdRenderer::jump() {
    std::printf("Clicked!");
//    this->readyToJump.store(true);
}
