//
//  BeeWithSpikeCollisionHandler.m
//  Beezle
//
//  Created by Marcus on 06/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWithSpikeCollisionHandler.h"
#import "BeeComponent.h"
#import "SpikeComponent.h"
#import "ArmoredComponent.h"
#import "EntityUtil.h"

@implementation BeeWithSpikeCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BeeComponent class]];
		[_secondComponentClasses addObject:[SpikeComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *beeEntity = firstEntity;

	if (![beeEntity hasComponent:[ArmoredComponent class]])
	{
		[EntityUtil destroyEntity:beeEntity];
	}

	return TRUE;
}

@end
