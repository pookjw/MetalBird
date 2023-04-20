//
//  GridRenderer.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/18/23.
//

#import <MetalBirdRenderer/BaseRenderer.hpp>
#import <array>

#define GRID_RENDERER_LENGTH 10
#define GRID_RENDERER_COUNT (GRID_RENDERER_LENGTH - 1) * 4

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class GridRenderer : public BaseRenderer {
public:
    using BaseRenderer::BaseRenderer;
    
    GridRenderer(
                 MTKView *mtkView,
                 id<MTLDevice> device,
                 id<MTLLibrary> library,
                 NSError * _Nullable __autoreleasing * error
                 );
    void mtkView_drawableSizeWillChange(MTKView *mtkView, struct CGSize size);
    void drawInMTKView(MTKView *mtkView);
private:
    static constinit const std::int16_t length;
    static constexpr const std::int16_t count();
    
    id<MTLRenderPipelineState> pipelineState;
    std::array<simd_float2, GRID_RENDERER_COUNT> coords;
    std::array<ushort, GRID_RENDERER_COUNT> indices;
    id<MTLBuffer> coordsBuffer;
    id<MTLBuffer> indicesBuffer;
    
    std::array<simd_float2, GRID_RENDERER_COUNT> makeCoords();
    std::array<ushort, GRID_RENDERER_COUNT> makeIndices();
};

NS_HEADER_AUDIT_END(nullability, sendability)
