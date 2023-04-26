//
//  BirdRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <array>
#import <optional>

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
    
    void drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size, NSUInteger screenFramesPerSecond);
    void jump();
private:
    id<MTLRenderPipelineState> pipelineState;
    std::atomic<bool> readyToJump;
    std::atomic<std::float_t> time;
    std::atomic<std::float_t> lastY;
    std::atomic<std::optional<std::float_t>> baseY;
};

NS_HEADER_AUDIT_END(nullability, sendability)
