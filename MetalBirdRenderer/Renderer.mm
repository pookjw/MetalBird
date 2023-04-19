//
//  Renderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/16/23.
//

#import <MetalBirdRenderer/Renderer.h>
#import <MetalBirdRenderer/constants.h>
#import <MetalBirdRenderer/GridRenderer.hpp>
#import <MetalBirdRenderer/BirdRenderer.hpp>
#import <memory>
#import <vector>
#import <algorithm>

/*
 TODO:
 - MTLBinaryArchive + MTLFunctionDescriptor
 */

@interface Renderer () <MTKViewDelegate>
@property (strong) NSOperationQueue *queue;

@property (strong, nullable) MTKView *mtkView;
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLLibrary> library;

@property (assign) std::shared_ptr<std::vector<std::shared_ptr<BaseRenderer>>> renderers;
@end

@implementation Renderer

- (instancetype)init {
    if (self = [super init]) {
        [self setupQueue];
    }
    
    return self;
}

- (void)setupWithMTKView:(MTKView *)mtkView completionHandler:(void (^)(NSError * _Nullable __autoreleasing error))completionHandler {
    [self.queue addOperationWithBlock:^{
        if (self.mtkView) {
            completionHandler([NSError errorWithDomain:MetalBirdRendererErrorDomain code:MetalBirdRendererErrorAlreadySetup userInfo:nil]);
            return;
        }
        
        NSError * _Nullable __autoreleasing error = nil;
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        NSBundle *bundle = [NSBundle bundleWithIdentifier:MetalBirdRendererBundleIdentifier];
        id<MTLLibrary> library = [device newDefaultLibraryWithBundle:bundle error:&error];
        if (error) {
            completionHandler(error);
            return;
        }
        
        //
        
        mtkView.device = device;
        mtkView.delegate = self;
        mtkView.clearColor = MTLClearColorMake(1.f, 1.f, 1.f, 1.f);
        
        self.mtkView = mtkView;
        self.device = device;
        self.library = library;
        
        //
        
        self.renderers = std::shared_ptr<std::vector<std::shared_ptr<BaseRenderer>>>(new std::vector<std::shared_ptr<BaseRenderer>> {
            std::shared_ptr<GridRenderer>(new GridRenderer(mtkView, device, library, &error)),
            std::shared_ptr<BirdRenderer>(new BirdRenderer(mtkView, device, library, &error))
        });
        if (error) {
            completionHandler(error);
            return;
        }
        
        completionHandler(nil);
    }];
}

- (void)setupQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.maxConcurrentOperationCount = 1;
    self.queue = queue;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self.queue addOperationWithBlock:^{
        std::for_each(self.renderers.get()->begin(), self.renderers.get()->end(), [&view, &size](std::shared_ptr<BaseRenderer> ptr) {
            ptr.get()->mtkView_drawableSizeWillChange(view, size);
        });
    }];
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    [self.queue addOperationWithBlock:^{
        std::for_each(self.renderers.get()->begin(), self.renderers.get()->end(), [&view](std::shared_ptr<BaseRenderer> ptr) {
            ptr.get()->drawInMTKView(view);
        });
    }];
}

@end
