//
//  Renderer.mm
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/16/23.
//

#import <MetalBirdRenderer/Renderer.h>
#import <MetalBirdRenderer/constants.h>
#import <MetalBirdRenderer/GridRenderer.hpp>
#import <memory>

/*
 TODO:
 - MTLBinaryArchive + MTLFunctionDescriptor
 */

@interface Renderer () <MTKViewDelegate>
@property (strong, nullable) MTKView *mtkView;
@property (strong) NSOperationQueue *queue;

@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;

@property (assign) std::shared_ptr<GridRenderer> gridRenderer;
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
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
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
        
        self.gridRenderer = std::shared_ptr<GridRenderer>(new GridRenderer(mtkView, device, library, &error));
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
        id<MTLCommandBuffer> commandBuffer = self.commandQueue.commandBuffer;
        MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
        
        //
        
        self->_gridRenderer.get()->renderWithEncoder(renderEncoder, size);
        
        //
        
        [renderEncoder endEncoding];
        id<CAMetalDrawable> drawable = view.currentDrawable;
        [commandBuffer presentDrawable:drawable];
        [commandBuffer commit];
    }];
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    
}

@end
