//
//  ObstacleRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/24/23.
//

#import <MetalBirdRenderer/ObstacleRenderer.hpp>
#import <MetalBirdRenderer/obstacle_common.hpp>
#import <iostream>

constinit const std::float_t ObstacleRenderer::obstaclesAbsoluteSpacing = 500.f;
const std::float_t ObstacleRenderer::holeSpacingRatio = std::powf(3.f, -1.f);
constinit const std::float_t ObstacleRenderer::obstacleAbsoluteWidth = 50.f;

ObstacleRenderer::ObstacleRenderer(
                                   MTKView *mtkView,
                                   id<MTLDevice> device,
                                   id<MTLLibrary> library,
                                   NSError * _Nullable __autoreleasing * error
                                   ) : BaseRenderer(mtkView, device, library, error)
{
    MTLFunctionDescriptor *vertexFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    vertexFunctionDescriptor.name = @"obstacle::vertex_main";
    
    id<MTLFunction> vertexFunction = [library newFunctionWithDescriptor:vertexFunctionDescriptor error:error];
    if (*error) return;
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"obstacle::fragment_main";
    
    id<MTLFunction> fragmentFunction = [library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) return;
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.rasterSampleCount = mtkView.sampleCount;
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    // TODO
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    
    this->pipelineState = pipelineState;
}

void ObstacleRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    const std::uint16_t obstaclesCount = static_cast<std::uint16_t>(std::ceilf(std::fmaf(std::fmaf(size.width, 1.f, std::fmaf(ObstacleRenderer::obstacleAbsoluteWidth, -1.f, 0.f)), std::powf(std::fmaf(ObstacleRenderer::obstacleAbsoluteWidth, 1.f, ObstacleRenderer::obstaclesAbsoluteSpacing), -1.f), 0.f)));
    
    const obstacle::data data = {
        
    };
}
