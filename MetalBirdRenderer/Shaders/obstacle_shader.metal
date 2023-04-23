//
//  obstacle_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/23/23.
//

#include <metal_stdlib>
using namespace metal;

namespace obstacle {
    struct vertex_out {
        float4 position [[position]];
        float pointSize [[point_size]];
    };
    
    vertex vertex_out vertex_main(
                                  uint vertexID [[vertex_id]]
                                  )
    {
        return {};
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(0.8f, 0.f, 1.f, 0.f);
    }
};
