//
//  SolidWithBoostCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithBoostCollisionHandler.h"
#import "BoostComponent.h"
#import "PhysicsComponent.h"
#import "SolidComponent.h"

@implementation SolidWithBoostCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[BoostComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *solidEntity = firstEntity;
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:solidEntity];
	ChipmunkBody *body = [physicsComponent body];
	cpVect force;
	force.x = body.vel.x;
	force.y = body.vel.y;
	[body applyImpulse:force offset:CGPointZero];
	
	return TRUE;
}

@end
