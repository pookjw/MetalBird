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
                                  constant obstacle::data &data [[buffer(0)]],
                                  const uint vertex_id [[vertex_id]]
                                  )
    {
        const float obstacles_relative_spacing = data.obstacles_absolute_spacing / data.drawable_size.x;
        const float relative_width = data.absolute_width / data.drawable_size.x;
        
        // multiplying 2.f converts [0.f, 1.f] space to [-1.f, 1.f] space.
        const float base_x = -1.f + 2.f * (obstacles_relative_spacing * (data.index + 1) + relative_width * data.index) - data.time;
        
        float4 position;
        
        switch (vertex_id) {
            case 0: {
                if (data.is_upper) {
                    position = {base_x, 1.f, 0.f, 1.f};
                } else {
                    position = {base_x, -1.f * data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                }
                break;
            }
            case 1: {
                if (data.is_upper) {
                    position = {base_x + relative_width, 1.f, 0.f, 1.f};
                } else {
                    position = {base_x + relative_width, -1.f * data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                }
                break;
            }
            case 2: {
                if (data.is_upper) {
                    position = {base_x + relative_width, data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                } else {
                    position = {base_x + relative_width, -1.f, 0.f, 1.f};
                }
                break;
            }
            case 3: {
                if (data.is_upper) {
                    position = {base_x, 1.f, 0.f, 1.f};
                } else {
                    position = {base_x, -1.f * data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                }
                break;
            }
            case 4: {
                if (data.is_upper) {
                    position = {base_x, data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                } else {
                    position = {base_x, -1.f, 0.f, 1.f};
                }
                break;
            }
            case 5: {
                if (data.is_upper) {
                    position = {base_x + relative_width, data.hole_spacing_ratio + data.offset, 0.f, 1.f};
                } else {
                    position = {base_x + relative_width, -1.f, 0.f, 1.f};
                }
                break;
            }
            default:
                position = {};
                break;
        }
        
        return {
            .position = position
        };
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return float4(0.8f, 0.f, 1.f, 0.f);
    }
};
