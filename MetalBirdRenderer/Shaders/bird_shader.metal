//
//  bird_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/17/23.
//

#include <metal_stdlib>
#import <MetalBirdRenderer/bird_common.hpp>
using namespace metal;

namespace bird {
    struct vertex_out {
        const float4 position [[position]];
        const float pointSize [[point_size]];
    };
    
    vertex vertex_out vertex_main(
                                  constant bird::data &data [[buffer(0)]],
                                  const uint vertexID [[vertex_id]]
                                  )
    {
        return {
            .position = float4(data.relative_x, data.relative_y, 0.f, 1.f),
            .pointSize = data.drawable_size.x * data.relative_point_size
        };
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(0.7f, 0.3f, 1.f, 0.f);
    }
};

