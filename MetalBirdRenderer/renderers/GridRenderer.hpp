//
//  GridRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <memory>
#import <array>

#define GRID_RENDERER_LENGTH 10
#define GRID_RENDERER_COUNT (GRID_RENDERER_LENGTH - 1) * 4

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class GridRenderer : public BaseRenderer {
public:
    GridRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error
                 );
    void renderWithEncoder(id<MTLRenderCommandEncoder> encoder, CGSize size);
private:
    std::array<simd_float2, GRID_RENDERER_COUNT> coords();
    
    id<MTLRenderPipelineState> pipelineState;
};

NS_HEADER_AUDIT_END(nullability, sendability)
