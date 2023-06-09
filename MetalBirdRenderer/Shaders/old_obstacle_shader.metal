//
//  old_obstacle_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#include <metal_stdlib>
using namespace metal;

namespace old_obstacle {
    struct vertex_in {
        const simd_float2 position [[attribute(0)]];
    };
    
    struct vertex_out {
        const float4 position [[position]];
    };
    
    vertex vertex_out vertex_main(
                                  vertex_in in [[stage_in]]
                                  )
    {
        return {
            .position = float4(in.position, 0.f, 1.f)
        };
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(0.8f, 0.f, 1.f, 0.f);
    }
};
