//
//  BeeWithTeleportCollisionHandler.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWithTeleportCollisionHandler.h"
#import "TeleportComponent.h"
#import "RenderComponent.h"
#import "PhysicsComponent.h"
#import "SoundManager.h"
#import "BeeComponent.h"

@implementation BeeWithTeleportCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BeeComponent class]];
		[_secondComponentClasses addObject:[TeleportComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *beeEntity = firstEntity;
	Entity *teleportEntity = secondEntity;

	TeleportComponent *teleportComponent = [TeleportComponent getFrom:teleportEntity];
	[teleportComponent addTeleportingEntity:beeEntity];

	[[RenderComponent getFrom:beeEntity] hide];
	[[PhysicsComponent getFrom:beeEntity] disable];
	[firstEntity refresh];

	return FALSE;
}

@end
