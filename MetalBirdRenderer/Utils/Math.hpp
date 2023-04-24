//
//  Math.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/22/23.
//

#import <cmath>

namespace Math {
const std::float_t toRadians(const std::float_t degrees);
const std::float_t toDegrees(const std::float_t radians);
const std::float_t projectileMotionY(
                                     const std::float_t vy,
                                     const std::float_t gravity,
                                     const std::float_t time
                                     );
};
