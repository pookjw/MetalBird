//
//  ObstacleRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#import <MetalBirdRenderer/Old_ObstacleRenderer.hpp>
#import <algorithm>
#import <iostream>
#import <ranges>
#import <tuple>

constinit const std::float_t Old_ObstacleRenderer::obstaclesAbsoluteSpacing = 100.f;
const std::float_t Old_ObstacleRenderer::holeSpacingRatio = std::powf(3.f, -1.f);
constinit const std::float_t Old_ObstacleRenderer::obstacleAbsoluteWidth = 50.f;

Old_ObstacleRenderer::Old_ObstacleRenderer(
                                           MTKView *mtkView,
                                           id<MTLDevice> device,
                                           id<MTLLibrary> library,
                                           NSError * _Nullable __autoreleasing * error
                                           ) : BaseRenderer(mtkView, device, library, error)
{
    MTLFunctionDescriptor *vertexFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    vertexFunctionDescriptor.name = @"old_obstacle::vertex_main";
    
    id<MTLFunction> vertexFunction = [library newFunctionWithDescriptor:vertexFunctionDescriptor error:error];
    if (*error) return;
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"old_obstacle::fragment_main";
    
    id<MTLFunction> fragmentFunction = [library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) return;
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.rasterSampleCount = mtkView.sampleCount;
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
    this->obstacles = std::shared_ptr<std::vector<simd_float2>>(new std::vector<simd_float2>());
}

void Old_ObstacleRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    const std::int16_t obstaclesCount = static_cast<std::int16_t>(std::fmaf(size.width, std::powf(std::fmaf(Old_ObstacleRenderer::obstaclesAbsoluteSpacing, 1.f, Old_ObstacleRenderer::obstaclesAbsoluteSpacing), -1.f), 0.f));
    
    std::vector<simd_float2> obstacles (obstaclesCount * 8);
    std::vector<std::uint16_t> indices (obstaclesCount * 12);
    
    const std::float_t obstaclesRelativeSpacing = std::fmaf(Old_ObstacleRenderer::obstaclesAbsoluteSpacing, std::powf(size.width, -1.f), 0.f);
    const std::float_t obstacleRelativeWidth = std::fmaf(Old_ObstacleRenderer::obstacleAbsoluteWidth, std::powf(size.width, -1.f), 0.f);
    const std::float_t unit = std::fmaf(obstaclesRelativeSpacing, 1.f, obstacleRelativeWidth);
    
    //
    
    std::vector<std::uint16_t> ranges (obstaclesCount);
    std::for_each(ranges.begin(), ranges.end(), [&ranges, &obstacles, &obstacleRelativeWidth, &unit, &indices](std::uint16_t &value) {
        std::uint16_t index = &value - ranges.data();
        std::float_t startX = std::fmaf(unit, index, 0.f);
        
        // upper obstacle
        obstacles.at(index * 8) = simd_make_float2(0.9f - index * 0.4f, 1.f);
        obstacles.at(index * 8 + 1) = simd_make_float2(1.f - index * 0.4f, 1.f);
        obstacles.at(index * 8 + 2) = simd_make_float2(1.f - index * 0.4f, 0.3f);
        obstacles.at(index * 8 + 3) = simd_make_float2(0.9f - index * 0.4f, 0.3f);
        
        // lower obstacle
        obstacles.at(index * 8 + 4) = simd_make_float2(0.9f - index * 0.4f, -0.3f);
        obstacles.at(index * 8 + 5) = simd_make_float2(1.f - index * 0.4f, -0.3f);
        obstacles.at(index * 8 + 6) = simd_make_float2(1.f - index * 0.4f, -1.f);
        obstacles.at(index * 8 + 7) = simd_make_float2(0.9f - index * 0.4f, -1.f);
    });
    
    //
    
    std::vector<std::uint16_t> ranges_2 (obstaclesCount * 2);
    std::for_each(ranges_2.begin(), ranges_2.end(), [&ranges_2, &indices](std::uint16_t &value) {
        std::uint16_t index = &value - ranges_2.data();
        
        indices.at(index * 6) = index * 4;
        indices.at(index * 6 + 1) = index * 4 + 1;
        indices.at(index * 6 + 2) = index * 4 + 2;
        indices.at(index * 6 + 3) = index * 4 + 0;
        indices.at(index * 6 + 4) = index * 4 + 3;
        indices.at(index * 6 + 5) = index * 4 + 2;
    });
    
    //
    
    [renderEncoder setRenderPipelineState:this->pipelineState];
    
    id<MTLBuffer> obstaclesBuffer = [this->device newBufferWithBytes:obstacles.data() length:obstacles.size() * sizeof(simd_float2) options:0];
    id<MTLBuffer> indicesBuffer = [this->device newBufferWithBytes:indices.data() length:indices.size() * sizeof(std::uint16_t) options:0];
    
    [renderEncoder setVertexBuffer:obstaclesBuffer offset:0 atIndex:0];
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeFill];
    
    std::for_each(ranges_2.begin(), ranges_2.end(), [&ranges_2, &indices, &renderEncoder, &indicesBuffer](std::uint16_t &value) {
        std::uint16_t index = &value - ranges_2.data();
        
        @autoreleasepool {
            [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                      indexCount:6
                                       indexType:MTLIndexTypeUInt16
                                     indexBuffer:indicesBuffer
                               indexBufferOffset:sizeof(std::uint16_t) * index * 6];
        }
    });
}
