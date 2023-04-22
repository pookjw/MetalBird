//
//  DynamicMTKView.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/20/23.
//

#import <MetalBirdRenderer/DynamicMTKView.h>
#import <MetalBirdRenderer/UIWindowScene+DidChangeScreenNotification.hpp>
#import <objc/message.h>
#import <TargetConditionals.h>

@implementation DynamicMTKView

#if TARGET_OS_IPHONE

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (self.window.windowScene) {
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:__UIWindowSceneDidChangeScreenNotification
                                                    object:self.window.windowScene];
    }
    
    [super willMoveToWindow:newWindow];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window.windowScene) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didChangeScreen:)
                                                   name:__UIWindowSceneDidChangeScreenNotification
                                                 object:self.window.windowScene];
    }
}

#elif TARGET_OS_OSX

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    if (self.window) {
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:NSWindowDidChangeScreenNotification
                                                    object:self.window];
    }
    
    [super viewWillMoveToWindow:newWindow];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (self.window) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didChangeScreen:)
                                                   name:NSWindowDidChangeScreenNotification
                                                 object:self.window];
    }
}

#endif

- (void)didChangeScreen:(NSNotification *)notification {
#if TARGET_OS_IPHONE
    self.preferredFramesPerSecond = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(self.window.windowScene.screen, NSSelectorFromString(@"maximumFramesPerSecond"));
#elif TARGET_OS_OSX
    self.preferredFramesPerSecond = self.window.screen.maximumFramesPerSecond;
#endif
}

@end
