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

@interface PhysicsComponent : Component
{
    PhysicsBody *_physicsBody;
    NSArray *_physicsShapes;
}

@property (nonatomic, readonly) PhysicsBody *physicsBody;
@property (nonatomic, readonly) NSArray *physicsShapes;

+(id) componentWithBody:(PhysicsBody *)body andShapes:(NSArray *)shapes;
+(id) componentWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape;

-(id) initWithBody:(PhysicsBody *)body andShapes:(NSArray *)shapes;
-(id) initWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape;
-(PhysicsShape *) firstPhysicsShape;

@end
