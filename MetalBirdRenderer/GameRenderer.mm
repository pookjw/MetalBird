//
//  GameRenderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/16/23.
//

#import <MetalBirdRenderer/GameRenderer.h>
#import <MetalBirdRenderer/constants.h>
#import <MetalBirdRenderer/GridRenderer.hpp>
#import <MetalBirdRenderer/BirdRenderer.hpp>
#import <MetalBirdRenderer/ObstacleRenderer.hpp>
#import <memory>
#import <vector>
#import <algorithm>
#import <optional>

/*
 TODO:
 - MTLBinaryArchive + MTLFunctionDescriptor
 */

@interface GameRenderer () <MTKViewDelegate>
@property (strong) NSOperationQueue *queue;

@property (strong, nullable) MTKView *mtkView;
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;

@property (assign) std::shared_ptr<std::vector<std::shared_ptr<BaseRenderer>>> renderers;
@property (assign) std::float_t timer;
@end

@implementation GameRenderer

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
        id<MTLCommandQueue> commandQueue = device.newCommandQueue;
        
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
        self.commandQueue = commandQueue;
        self.library = library;
        
        //
        
        self.renderers = std::shared_ptr<std::vector<std::shared_ptr<BaseRenderer>>>(new std::vector<std::shared_ptr<BaseRenderer>> {
            std::shared_ptr<GridRenderer>(new GridRenderer(mtkView, device, library, &error)),
            std::shared_ptr<ObstacleRenderer>(new ObstacleRenderer(mtkView, device, library, &error)),
            std::shared_ptr<BirdRenderer>(new BirdRenderer(mtkView, device, library, &error))
        });
        if (error) {
            completionHandler(error);
            return;
        }
        
        completionHandler(nil);
    }];
}

- (void)jumpBird:(id _Nullable)sender {
    [self.queue addOperationWithBlock:^{
        std::for_each(self.renderers.get()->begin(), self.renderers.get()->end(), [](std::shared_ptr<BaseRenderer> ptr) {
            BaseRenderer *baseRenderer = ptr.get();
            BirdRenderer *birdRenderer = dynamic_cast<BirdRenderer *>(baseRenderer);
            if (birdRenderer == nullptr) return;
            
            birdRenderer->jump();
        });
    }];
}

- (void)setupQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.maxConcurrentOperationCount = 1;
    self.queue = queue;
}

- (void)renderWithView:(MTKView *)mtkView size:(std::optional<CGSize>)size {
    CGSize drawableSize = size.value_or([mtkView.currentDrawable layer].drawableSize);
    
    [self.queue addOperationWithBlock:^{
        id<MTLCommandBuffer> commandBuffer = self->_commandQueue.commandBuffer;
        MTLRenderPassDescriptor * _Nullable descriptor = mtkView.currentRenderPassDescriptor;
        if (descriptor == nil) return;
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
        
        std::for_each(self.renderers.get()->begin(), self.renderers.get()->end(), [&renderEncoder, &drawableSize](std::shared_ptr<BaseRenderer> ptr) {
            @autoreleasepool {
                ptr.get()->drawInRenderEncoder(renderEncoder, drawableSize);
            }
        });
        
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:mtkView.currentDrawable];
        [commandBuffer commit];
    }];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self renderWithView:view size:std::optional<CGSize>(size)];
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    [self renderWithView:view size:std::nullopt];
}

@end
