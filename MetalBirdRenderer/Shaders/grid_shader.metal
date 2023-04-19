//
//  grid_shader.metal
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/17/23.
//

#import <metal_stdlib>
using namespace metal;

namespace grid {
    vertex float4 vertex_main(simd_float2 position [[attribute(0)]] [[stage_in]]) {
        return float4(position, 0.f, 1.f);
    }
    
    fragment float4 fragment_main() {
        return float4(0.f, 0.f, 0.f, 1.f);
    }
};

