//
//  ObstacleRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/24/23.
//

#import <MetalBirdRenderer/ObstacleRenderer.hpp>

constinit const std::float_t ObstacleRenderer::obstaclesAbsoluteSpacing = 100.f;
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
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(simd_float2);
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:error];
    
    this->pipelineState = pipelineState;
}

void ObstacleRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
}
