//
//  SawWithWoodCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SawWithWoodCollisionHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"
#import "SawComponent.h"
#import "WoodComponent.h"

@implementation SawWithWoodCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SawComponent class]];
		[_secondComponentClasses addObject:[WoodComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *sawEntity = firstEntity;
	Entity *woodEntity = secondEntity;
	
	[EntityUtil destroyEntity:sawEntity instant:TRUE];
	
	WoodComponent *woodComponent = [WoodComponent getFrom:woodEntity];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:woodEntity];
	int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision secondShape]];
	[woodComponent setShapeIndexAtCollision:shapeIndexAtCollision];
	[EntityUtil destroyEntity:secondEntity];
	
	return FALSE;
}

@end
