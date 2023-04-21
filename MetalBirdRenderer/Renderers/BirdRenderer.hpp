//
//  BirdRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <array>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class BirdRenderer : public BaseRenderer {
public:
    using BaseRenderer::BaseRenderer;
    
    BirdRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error 
                 );
    
    void drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, std::optional<CGSize> size);
    void jump();
private:
    static constinit const std::float_t angle;
    id<MTLRenderPipelineState> pipelineState;
    std::atomic<bool> readyToJump;
    bool increasing;
    std::float_t timer;
};

NS_HEADER_AUDIT_END(nullability, sendability)
