//
//  BirdRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/BirdRenderer.hpp>
#import <MetalBirdRenderer/Math.hpp>
#import <MetalBirdRenderer/bird_common.hpp>
#import <iostream>
#import <cmath>

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

void BirdRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    [renderEncoder setRenderPipelineState:this->pipelineState];
    
    float y;
    
    if (this->readyToJump.load()) {
        float time = std::fmaf(this->time.load(), 1.f, 0.1f);
        
        y = std::fmaf(-1.f, 1.f, Math::projectileMotionY(0.3f, 0.1f, time));
        
        std::optional<std::float_t> baseY = this->baseY.load();
        if (baseY != std::nullopt) {
            y += baseY.value() + 1.f;
        }
        
        if (std::isgreaterequal(y, 1.f)) {
            time = 3.f; // time when projection reached to the highest point. (t = v / g)
            
            // 0.55f = the highest point is 0.45f. 1.f - 0.45f = 0.55f.
            y = 1.f + 0.55f + std::fmaf(-1.f, 1.f, Math::projectileMotionY(0.3f, 0.1f, time));
            this->time.store(time);
            this->baseY.store(0.55f);
        } else if (std::islessequal(y, -1.f)) {
            y = -1.f;
            this->time.store(0.f);
            this->readyToJump.store(false);
            this->baseY.store(std::nullopt);
        } else {
            this->time.store(time);
        }
        
        this->lastY.store(y);
    } else {
        y = -1.f;
    }
    
    bird::data data = {
        .drawable_size = simd_make_float2(size.width, size.height),
        .relative_point_size = 0.05f,
        .relative_x = -0.7f,
        .relative_y = y
    };
    
    id<MTLBuffer> dataBuffer = [this->device newBufferWithBytes:&data length:sizeof(data) options:0];
    
    [renderEncoder setVertexBuffer:dataBuffer offset:0 atIndex:0];
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypePoint
                      vertexStart:0
                      vertexCount:1];
}

void BirdRenderer::jump() {
    this->time.store(0.f);
    
    if (this->readyToJump.load()) {
        this->baseY.store(this->lastY.load());
    }
    
    this->readyToJump.store(true);
}
