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
    
    void mtkView_drawableSizeWillChange(MTKView *mtkView, struct CGSize size);
    void drawInMTKView(MTKView *mtkView);
private:
    id<MTLRenderPipelineState> pipelineState;
    float timer;
};

NS_HEADER_AUDIT_END(nullability, sendability)
