//
//  ObstacleRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/24/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <vector>
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
    static constinit const std::float_t obstaclesAbsoluteSpacing;
    static const std::float_t holeSpacingRatio;
    static constinit const std::float_t obstacleAbsoluteWidth;
    
    id<MTLRenderPipelineState> pipelineState;
    std::float_t time;
    std::shared_ptr<std::vector<std::float_t>> randomValues;
};

NS_HEADER_AUDIT_END(nullability, sendability)

