//
//  constants.h
//  MetalBird
//
//  Created by Jinwoo Kim on 4/17/23.
//

#import <Foundation/Foundation.h>

static NSErrorDomain const MetalBirdRendererErrorDomain = @"MetalBirdRendererErrorDomain";

NS_ERROR_ENUM(MetalBirdRendererErrorDomain) {
    MetalBirdRendererErrorAlreadySetup = 0b1
};
