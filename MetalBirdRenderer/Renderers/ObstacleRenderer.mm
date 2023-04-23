//
//  ObstacleRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#import <MetalBirdRenderer/ObstacleRenderer.hpp>
#import <algorithm>
#import <iostream>
#import <ranges>

constinit const std::float_t ObstacleRenderer::obstaclesSpacing = 100.f;
const std::float_t ObstacleRenderer::holeSpacingRatio = std::powf(-3.f, -1.f);
constinit const std::float_t ObstacleRenderer::obstacleWidth = 50.f;

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
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    /* TODO */
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    
    this->pipelineState = pipelineState;
    this->obstacles = std::shared_ptr<std::vector<simd_float2>>(new std::vector<simd_float2>());
}

void ObstacleRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    std::int16_t obstaclesCount = static_cast<std::int16_t>(std::fmaf(size.width, std::powf(std::fmaf(ObstacleRenderer::obstaclesSpacing, 1.f, ObstacleRenderer::obstaclesSpacing), -1.f), 0.f));
    
}
