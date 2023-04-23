//
//  ObstacleRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <vector>
#import <array>
#import <memory>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class ObstacleRenderer : public BaseRenderer {
public:
    using BaseRenderer::BaseRenderer;
    
    ObstacleRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error 
                 );
    
    void drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size);
private:
    static constinit const std::float_t obstaclesSpacing;
    static const std::float_t holeSpacingRatio;
    static constinit const std::float_t obstacleWidth;
    
    id<MTLRenderPipelineState> pipelineState;
    std::shared_ptr<std::vector<simd_float2>> obstacles;
};

NS_HEADER_AUDIT_END(nullability, sendability)
