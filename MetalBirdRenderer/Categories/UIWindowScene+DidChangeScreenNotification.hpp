//
//  UIWindowScene+DidChangeScreenNotification.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/19/23.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const __UIWindowSceneDidChangeScreenNotification = @"__UIWindowSceneDidChangeScreenNotification";

@interface UIWindowScene (DidChangeScreenNotification)
@end

NS_ASSUME_NONNULL_END

#endif
