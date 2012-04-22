//
//  SolidWithWaterCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithWaterCollisionHandler.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "SolidComponent.h"
#import "TransformComponent.h"
#import "WaterComponent.h"

@implementation SolidWithWaterCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[WaterComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *solidEntity = firstEntity;
	Entity *waterEntity = secondEntity;
	
	[EntityUtil destroyEntity:solidEntity instant:TRUE];
	
	WaterComponent *waterComponent = [WaterComponent getFrom:waterEntity];
	Entity *splashEntity = [EntityFactory createEntity:[waterComponent splashEntityType] world:_world];
	TransformComponent *transformComponent = [TransformComponent getFrom:firstEntity];
	[EntityUtil setEntityPosition:splashEntity position:[transformComponent position]];
	[EntityUtil destroyEntity:splashEntity];
	
	return FALSE;
}

@end
