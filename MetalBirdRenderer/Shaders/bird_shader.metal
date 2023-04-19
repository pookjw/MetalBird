//
//  bird_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/17/23.
//

#include <metal_stdlib>
using namespace metal;

namespace bird {
    struct vertex_in {
        
    };
    
    struct vertex_out {
        float4 position [[position]];
        float pointSize [[point_size]];
    };
    
    vertex vertex_out vertex_main(
                                  constant float &timer [[buffer(0)]],
                                  uint vertexID [[vertex_id]]
                                  )
    {
        return {
            .position = float4(-0.5f, (-2.f) * pow(timer, 2) + 1.f, 0.f, 1.f),
            .pointSize = 30
        };
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(1.f, 0.f, 0.f, 0.f);
    }
};

