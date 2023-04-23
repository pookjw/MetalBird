//
//  ObstacleRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>

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
    id<MTLRenderPipelineState> pipelineState;
};

NS_HEADER_AUDIT_END(nullability, sendability)
