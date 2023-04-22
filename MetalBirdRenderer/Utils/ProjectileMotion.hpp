//
//  ProjectileMotion.hpp
//  MetalBirdRenderer
//
//  Created by Jinwoo Kim on 4/22/23.
//

#import <array>

class ProjectileMotion {
public:
    static const std::float_t y(
                                const std::float_t velocity,
                                const std::float_t radian,
                                const std::float_t gravity,
                                const std::float_t time
                                );
private:
    ProjectileMotion();
};
