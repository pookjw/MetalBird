//
//  DynamicMTKView.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/20/23.
//

#import <MetalBirdRenderer/DynamicMTKView.h>
#import <MetalBirdRenderer/UIWindowScene+UIWindowDidChangeScreenNotification.hpp>
#import <objc/message.h>

@implementation DynamicMTKView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [NSNotificationCenter.defaultCenter removeObserver:self name:__UIWindowDidChangeScreenNotification object:self.window.windowScene];
    [super willMoveToWindow:newWindow];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window.windowScene) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didChangeScreen:)
                                                   name:__UIWindowDidChangeScreenNotification
                                                 object:self.window.windowScene];
    }
}

- (void)didChangeScreen:(NSNotification *)notification {
    self.preferredFramesPerSecond = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(self.window.windowScene.screen, NSSelectorFromString(@"maximumFramesPerSecond"));
}

@end
