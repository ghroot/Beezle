//
//  BeeWithBeeaterCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWithBeeaterCollisionHandler.h"
#import "BeeComponent.h"
#import "BeeaterComponent.h"
#import "CapturedComponent.h"
#import "EntityUtil.h"

@implementation BeeWithBeeaterCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BeeComponent class]];
		[_secondComponentClasses addObject:[BeeaterComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *beeEntity = firstEntity;
	Entity *beeaterEntity = secondEntity;
	
	BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
	if ([beeComponent killsBeeaters])
	{
		[beeComponent decreaseBeeaterHitsLeft];
		if ([beeComponent isOutOfBeeaterKills])
		{
			[EntityUtil destroyEntity:beeEntity];
		}
		
		CapturedComponent *capturedComponent = [CapturedComponent getFrom:beeaterEntity];
		[capturedComponent setDestroyedByBeeType:[beeComponent type]];
		[EntityUtil destroyEntity:beeaterEntity];
	}
	
	return TRUE;
}

@end
