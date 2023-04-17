//
//  GridRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class GridRenderer : public BaseRenderer {
//    using BaseRenderer::BaseRenderer;
public:
    GridRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error
                 );
    void renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size);
};

NS_HEADER_AUDIT_END(nullability, sendability)
