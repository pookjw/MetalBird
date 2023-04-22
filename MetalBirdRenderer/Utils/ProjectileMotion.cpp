//
//  ProjectileMotion.cpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/22/23.
//

#import <MetalBirdRenderer/ProjectileMotion.hpp>
#import <cmath>

const std::float_t ProjectileMotion::y(
                                       const std::float_t velocity,
                                       const std::float_t radian,
                                       const std::float_t gravity,
                                       const std::float_t time
                                       )
{
    return std::fmaf(std::fmaf(velocity, std::sinf(radian), 0.f), time, std::fmaf(std::powf(-2.f, -1.f), std::fmaf(gravity, std::powf(time, 2.f), 0.f), 0.f));
}
