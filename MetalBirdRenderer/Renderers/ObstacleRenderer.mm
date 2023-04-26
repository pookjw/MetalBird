//
//  ObstacleRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/24/23.
//

#import <MetalBirdRenderer/ObstacleRenderer.hpp>
#import <MetalBirdRenderer/obstacle_common.hpp>
#import <iostream>
#import <vector>
#import <random>

constinit const std::float_t ObstacleRenderer::obstaclesAbsoluteSpacing = 500.f;
const std::float_t ObstacleRenderer::holeSpacingRatio = std::powf(3.f, -1.f);
constinit const std::float_t ObstacleRenderer::obstacleAbsoluteWidth = 80.f;

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
    this->randomValues = std::shared_ptr<std::vector<std::float_t>> (new std::vector<std::float_t>);
}

void ObstacleRenderer::drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size) {
    BaseRenderer::drawInRenderEncoder(renderEncoder, size);
    
    // ((this->time) * size.width + size.width)
//    const std::uint16_t obstaclesCount = static_cast<std::uint16_t>(std::ceilf(std::fmaf(std::fmaf(std::fmaf(this->time, size.width, size.width), 1.f, std::fmaf(ObstacleRenderer::obstaclesAbsoluteSpacing, -1.f, 0.f)), std::powf(std::fmaf(ObstacleRenderer::obstacleAbsoluteWidth, 1.f, ObstacleRenderer::obstaclesAbsoluteSpacing), -1.f), 0.f)));
    // TODO
    const std::uint16_t obstaclesCount = std::floorf((this->time * size.width + size.width) / (ObstacleRenderer::obstacleAbsoluteWidth + ObstacleRenderer::obstaclesAbsoluteSpacing));
    
    std::cout << obstaclesCount << std::endl;
    
    //
    
    std::random_device randomDevice;
    std::mt19937_64 generator (randomDevice());
    std::uniform_real_distribution<std::float_t> distribution(-0.5f, 0.5f);
    
    const std::uint16_t randomValueSize = this->randomValues.get()->size();
    if (randomValueSize < obstaclesCount) {
        const std::vector<std::uint16_t> range (obstaclesCount - randomValueSize);
        std::cout << "A " << (obstaclesCount - randomValueSize) << std::endl;
        
        std::for_each(range.cbegin(), range.cend(), [randomValues = this->randomValues.get(), randomValueSize, &distribution, &generator](std::uint16_t value) {
            std::float_t randomFloat = distribution(generator);
            
            randomValues->push_back(randomFloat);
        });
    } else if (obstaclesCount < randomValueSize) {
        std::cout << "B " << (randomValueSize - obstaclesCount) << std::endl;
        const std::vector<std::uint16_t> range (randomValueSize - obstaclesCount);
        
        std::for_each(range.cbegin(), range.cend(), [randomValues = this->randomValues.get()](std::uint16_t value) {
            randomValues->erase(randomValues->begin());
//            randomValues->pop_back();
        });
    }
    
    //
    
    [renderEncoder setRenderPipelineState:this->pipelineState];
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeFill];
    
    this->time = std::fmaf(this->time, 1.f, 0.003f);
    
    if (std::isgreaterequal(this->time, std::fmaf(std::fmaf(std::fmaf(ObstacleRenderer::obstaclesAbsoluteSpacing, 1.f, ObstacleRenderer::obstacleAbsoluteWidth), std::powf(size.width, -1.f), 0.f), 2.f, 0.f))) {
        this->time = 0.f;
    }
    
    std::vector<std::uint16_t> range (obstaclesCount * 2);
    
    std::for_each(range.begin(), range.end(), [&range, size, time = this->time, device = this->device, renderEncoder, randomValues = this->randomValues.get()](std::uint16_t &value) {
        const std::uint16_t index = &value - range.data();
        
        const obstacle::data data = {
            .drawable_size = simd_make_float2(size.width, size.height),
            .obstacles_absolute_spacing = ObstacleRenderer::obstaclesAbsoluteSpacing,
            .hole_spacing_ratio = ObstacleRenderer::holeSpacingRatio,
            .absolute_width = ObstacleRenderer::obstacleAbsoluteWidth,
            .time = time,
            .index = static_cast<short>(index / 2),
            .is_upper = (index % 2) == 0,
            .offset = randomValues->at(index / 2)
        };
        
        id<MTLBuffer> dataBuffer = [device newBufferWithBytes:&data length:sizeof(data) options:0];
        
        [renderEncoder setVertexBuffer:dataBuffer offset:0 atIndex:0];
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];
    });
}
