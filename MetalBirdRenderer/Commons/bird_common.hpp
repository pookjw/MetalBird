//
//  bird_common.hpp
//  MetalBird
//
//  Created by Jinwoo Kim on 4/23/23.
//

#import <simd/simd.h>

namespace bird {
struct data {
    simd_float2 drawable_size;
    float relative_point_size;
    float relative_x;
    float relative_y;
};
}
