//
//  Math.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/22/23.
//

#import <cmath>

class Math {
public:
    static const std::float_t toRadians(const std::float_t degrees);
    static const std::float_t toDegrees(const std::float_t radians);
private:
    Math();
};
