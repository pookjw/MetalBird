//
//  Renderer.m
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/16/23.
//

#import "Renderer.h"
#import "constants.h"

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

@property (strong) id<MTLRenderPipelineState> gridPipelineState;
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
        
        NSURL *bundleURL = [[NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"MetalBirdRenderer_MetalBirdRenderer" isDirectory:YES] URLByAppendingPathExtension:@"bundle"];
        NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
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
        
        [self setupGridPipelineStateWithError:&error];
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

- (BOOL)setupGridPipelineStateWithError:(NSError * _Nullable __autoreleasing *)error {
    MTLFunctionDescriptor *vertexFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    vertexFunctionDescriptor.name = @"grid::vertex_main";
    
    id<MTLFunction> vertexFunction = [self.library newFunctionWithDescriptor:vertexFunctionDescriptor error:error];
    if (*error) {
        return NO;
    }
    
    MTLFunctionDescriptor *fragmentFunctionDescriptor = [MTLFunctionDescriptor functionDescriptor];
    fragmentFunctionDescriptor.name = @"grid::fragment_main";
    id<MTLFunction> fragmentFunction = [self.library newFunctionWithDescriptor:fragmentFunctionDescriptor error:error];
    if (*error) {
        return NO;
    }
    
    MTLRenderPipelineDescriptor *gridPipelineDescriptor = [MTLRenderPipelineDescriptor new];
    gridPipelineDescriptor.vertexFunction = vertexFunction;
    gridPipelineDescriptor.fragmentFunction = fragmentFunction;
    gridPipelineDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
//    gridPipelineDescriptor.vertexDescriptor = /* TODO */;
    
    id<MTLRenderPipelineState> gridPipelineState = [self.device newRenderPipelineStateWithDescriptor:gridPipelineDescriptor error:error];
    if (*error) {
        return NO;
    }
    
    self.gridPipelineState = gridPipelineState;
    
    return YES;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    
}

@end
