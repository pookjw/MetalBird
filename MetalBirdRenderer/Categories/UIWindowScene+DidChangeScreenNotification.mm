//
//  UIWindowScene+UIWindowDidChangeScreenNotification.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/UIWindowScene+DidChangeScreenNotification.hpp>
#import <objc/runtime.h>

namespace UIWindowScene_DidChangeScreenNotification {

static void (*original_screenDidChangeFromScreen_toScreen)(id, SEL, id, id);

static void custom_screenDidChangeFromScreen_toScreen(id self, SEL _cmd, id x2, id x3) {
    original_screenDidChangeFromScreen_toScreen(self, _cmd, x2, x3);
    
    [NSNotificationCenter.defaultCenter postNotificationName:__UIWindowSceneDidChangeScreenNotification object:self];
}

};

@implementation UIWindowScene (DidChangeScreenNotification)

+ (void)load {
    Method method = class_getInstanceMethod(self, NSSelectorFromString(@"_screenDidChangeFromScreen:toScreen:"));
    UIWindowScene_DidChangeScreenNotification::original_screenDidChangeFromScreen_toScreen = reinterpret_cast<void (*)(id, SEL, id, id)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(UIWindowScene_DidChangeScreenNotification::custom_screenDidChangeFromScreen_toScreen));
}

@end
