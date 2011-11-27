//
//  PhysicalBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "artemis.h"
#import "chipmunk.h"

@class PhysicsBody;
@class PhysicsShape;

typedef enum
{
    COLLISION_TYPE_NONE,
    COLLISION_TYPE_BACKGROUND,
    COLLISION_TYPE_BEE,
	COLLISION_TYPE_BEEATER,
    COLLISION_TYPE_RAMP,
    COLLISION_TYPE_POLLEN,
} collisionTypes;

@interface PhysicsComponent : Component
{
    PhysicsBody *_physicsBody;
    NSMutableArray *_physicsShapes;
}

@property (nonatomic, readonly) PhysicsBody *physicsBody;
@property (nonatomic, readonly) NSMutableArray *physicsShapes;

-(id) initWithBody:(PhysicsBody *)body andShapes:(NSMutableArray *)shapes;
-(id) initWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape;
-(PhysicsShape *) firstPhysicsShape;

@end
