//
//  DozerWithCrumbleCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DozerWithCrumbleCollisionHandler.h"
#import "CrumbleComponent.h"
#import "DozerComponent.h"
#import "EntityUtil.h"

@implementation DozerWithCrumbleCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[DozerComponent class]];
		[_secondComponentClasses addObject:[CrumbleComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *crumbleEntity = secondEntity;
	[EntityUtil destroyEntity:crumbleEntity];
	return FALSE;
}

@end
