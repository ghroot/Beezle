//
//  AnythingWithTeleportCollisionHandler.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnythingWithTeleportCollisionHandler.h"
#import "TeleportComponent.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "PhysicsComponent.h"

@implementation AnythingWithTeleportCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_secondComponentClasses addObject:[TeleportComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *teleportEntity = secondEntity;
	TeleportComponent *teleportComponent = [TeleportComponent getFrom:teleportEntity];
	[teleportComponent addTeleportingEntity:firstEntity];

	[[RenderComponent getFrom:firstEntity] hide];
	[[PhysicsComponent getFrom:firstEntity] disable];
	[firstEntity refresh];

	return FALSE;
}

@end
