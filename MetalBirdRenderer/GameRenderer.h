//
//  GameRenderer.h
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/16/23.
//

#import <MetalKit/MetalKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface GameRenderer : NSObject
- (void)setupWithMTKView:(MTKView *)mtkView completionHandler:(void (^)(NSError * _Nullable __autoreleasing error))completionHandler NS_SWIFT_NAME(setup(mtkView:completionHandler:));
- (void)jumpBird:(id _Nullable)sender;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
