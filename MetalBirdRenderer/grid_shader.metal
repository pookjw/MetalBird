//
//  grid_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/17/23.
//

#include <metal_stdlib>
#import <MetalBirdRenderer/grid_common.hpp>
using namespace metal;

namespace grid {
    struct vertex_out {
        float4 position [[position]];
    };
    
    vertex vertex_out vertex_main(vertex_in in [[stage_in]]) {
        return {};
    }
    
    fragment float4 fragment_main(vertex_out out [[stage_in]]) {
        return {};
    }
};

