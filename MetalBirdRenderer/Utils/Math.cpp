//
//  Math.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/22/23.
//

#import <MetalBirdRenderer/Math.hpp>
#import <numbers>
#import <cmath>

const std::float_t Math::toRadians(const std::float_t degrees) {
    return std::fmaf(degrees, std::fmaf(std::numbers::pi, std::powf(180.f, -1.f), 0.f), 0.f);
}

const std::float_t Math::toDegrees(const std::float_t radians) {
    return std::fmaf(radians, std::fmaf(std::powf(std::numbers::pi, -1.f), 180.f, 0.f), 0.f);
}

const std::float_t Math::projectileMotionY(
                                           const std::float_t vy,
                                           const std::float_t gravity,
                                           const std::float_t time
                                           )
{
    return std::fmaf(vy, time, std::fmaf(std::powf(-2.f, -1.f), std::fmaf(gravity, std::powf(time, 2.f), 0.f), 0.f));
}
