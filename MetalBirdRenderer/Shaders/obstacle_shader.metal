//
//  obstacle_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/24/23.
//

#include <metal_stdlib>
#import <MetalBirdRenderer/obstacle_common.hpp>
using namespace metal;

namespace obstacle {
    struct vertex_out {
        const float4 position [[position]];
    };
    
    vertex vertex_out vertex_main(
                                  constant obstacle::data &data [[buffer(0)]]
                                  )
    {
        return {
            .position = float4(0.f, 0.f, 0.f, 1.f)
        };
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(0.8f, 0.f, 1.f, 0.f);
    }
};
