//
//  GridRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/GridRenderer.hpp>

GridRenderer::GridRenderer(
                           MTKView *mtkView,
                           id<MTLDevice> device,
                           id<MTLLibrary> library,
                           NSError * _Nullable __autoreleasing * error
                           ) : BaseRenderer(mtkView, device, library, error)
{
    
}

void GridRenderer::renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size) {
    BaseRenderer::renderWithEncoder(encoder, size);
}
