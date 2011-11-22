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
    COLLISION_TYPE_BACKGROUND,
    COLLISION_TYPE_BEE,
    COLLISION_TYPE_RAMP,
} collisionTypes;

@interface PhysicsComponent : Component
{
    PhysicsBody *_body;
    NSMutableArray *_shapes;
}

@property (nonatomic, readonly) PhysicsBody *body;
@property (nonatomic, readonly) NSMutableArray *shapes;

-(id) initWithBody:(PhysicsBody *)body andShapes:(NSMutableArray *)shapes;
-(id) initWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape;
-(PhysicsShape *) shape;

@end
