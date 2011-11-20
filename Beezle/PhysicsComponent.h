//
//  PhysicalBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

#import "chipmunk.h"

typedef enum
{
    COLLISION_TYPE_BEE,
    COLLISION_TYPE_RAMP,
} collisionTypes;


@interface PhysicsComponent : Component
{
    cpBody *_body;
    cpShape *_shape;
}

@property (nonatomic, readonly) cpBody *body;
@property (nonatomic, readonly) cpShape *shape;

-(id) initWithBody:(cpBody *)body andShape:(cpShape *)shape;

@end
