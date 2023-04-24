//
//  obstacle_common.hpp
//  MetalBird
//
//  Created by Jinwoo Kim on 4/24/23.
//

#import <simd/simd.h>

namespace obstacle {
struct data {
    const simd_float2 drawable_size;
    const float obstacles_absolute_spacing;
    const float hole_spacing_ratio;
    const float absolute_width;
    const float time;
};
}
