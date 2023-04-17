//
//  BaseRenderer.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>

BaseRenderer::BaseRenderer(
                           MTKView *mtkView,
                           id<MTLDevice> device,
                           id<MTLLibrary> library,
                           NSError * _Nullable __autoreleasing * error
                           )
{
    
}

void BaseRenderer::renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size) {
    
}
