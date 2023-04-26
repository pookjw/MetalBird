//
//  BaseRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalKit/MetalKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class BaseRenderer {
public:
    BaseRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error
                 );
    
    virtual void drawInRenderEncoder(id<MTLRenderCommandEncoder> renderEncoder, CGSize size, NSUInteger screenFramesPerSecond);
protected:
    MTKView *mtkView;
    id<MTLDevice> device;
    id<MTLLibrary> library;
};

NS_HEADER_AUDIT_END(nullability, sendability)
