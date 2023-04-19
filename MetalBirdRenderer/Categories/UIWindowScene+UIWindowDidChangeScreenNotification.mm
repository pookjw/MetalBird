//
//  UIWindowScene+UIWindowDidChangeScreenNotification.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <MetalBirdRenderer/UIWindowScene+UIWindowDidChangeScreenNotification.hpp>
#import <objc/runtime.h>

namespace UIWindowScene_UIWindowDidChangeScreenNotification {

static void (*original_screenDidChangeFromScreen_toScreen)(id, SEL, id, id);

static void custom_screenDidChangeFromScreen_toScreen(id self, SEL _cmd, id x2, id x3) {
    original_screenDidChangeFromScreen_toScreen(self, _cmd, x2, x3);
    
    [NSNotificationCenter.defaultCenter postNotificationName:__UIWindowDidChangeScreenNotification object:self];
}

};

@implementation UIWindowScene (UIWindowDidChangeScreenNotification)

+ (void)load {
    Method method = class_getInstanceMethod(self, NSSelectorFromString(@"_screenDidChangeFromScreen:toScreen:"));
    UIWindowScene_UIWindowDidChangeScreenNotification::original_screenDidChangeFromScreen_toScreen = reinterpret_cast<void (*)(id, SEL, id, id)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(UIWindowScene_UIWindowDidChangeScreenNotification::custom_screenDidChangeFromScreen_toScreen));
}

@end
