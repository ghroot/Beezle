//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeSystem.h"
#import "BeeComponent.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"

@implementation BeeSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], [PhysicsComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
    BeeComponent *beeComponent = (BeeComponent *)[entity getComponent:[BeeComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	PhysicsBody *physicsBody = [physicsComponent physicsBody];
	cpBody *body = [physicsBody body];
	float velocityLength = sqrtf(body->v.x * body->v.x + body->v.y + body->v.y);
	if (velocityLength <= 10.0f)
	{
		// TODO: Destroy bee
	}
}

@end
