//
//  PossessWithSpiritCollisionHandler.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/02/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PossessWithSpiritCollisionHandler.h"
#import "PossessComponent.h"
#import "SpiritComponent.h"
#import "EntityUtil.h"
#import "SoundManager.h"

@implementation PossessWithSpiritCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[PossessComponent class]];
		[_secondComponentClasses addObject:[SpiritComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *possessEntity = firstEntity;
	Entity *spiritEntity = secondEntity;

	[EntityUtil destroyEntity:possessEntity instant:TRUE];
	[EntityUtil destroyEntity:spiritEntity];

	[[SoundManager sharedManager] playSound:@"FreedMumee"];

	return FALSE;
}

@end
