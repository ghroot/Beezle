//
//  TeleportSystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportSystem.h"
#import "TeleportComponent.h"
#import "TransformComponent.h"
#import "PhysicsComponent.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TeleportInfo.h"
#import "Utils.h"
#import "RenderComponent.h"

@implementation TeleportSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[TeleportComponent class]];
	return self;
}

-(void) dealloc
{
	[_teleportComponentMapper release];
	[_transformComponentMapper release];
	[_physicsComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_teleportComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TeleportComponent class]];
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	EditComponent *editComponent = [EditComponent getFrom:entity];
	if (editComponent != nil)
	{
		TeleportComponent *teleportComponent = [_teleportComponentMapper getComponentFor:entity];

		// Create teleport out position entity to allow for editing
		Entity *teleportOutPositionEntity = [EntityFactory createTeleportOutPosition:_world];
		[EntityUtil setEntityPosition:teleportOutPositionEntity position:[teleportComponent outPosition]];
		[EntityUtil setEntityRotation:teleportOutPositionEntity rotation:[teleportComponent outRotation]];
		[editComponent setTeleportOutPositionEntity:teleportOutPositionEntity];
	}
}

-(void) processEntity:(Entity *)entity
{
	TeleportComponent *teleportComponent = [_teleportComponentMapper getComponentFor:entity];

	EditComponent *editComponent = [EditComponent getFrom:entity];
	if (editComponent != nil)
	{
		Entity *teleportOutPositionEntity = [editComponent teleportOutPositionEntity];
		TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:teleportOutPositionEntity];
		[teleportComponent setOutPosition:[transformComponent position]];
		[teleportComponent setOutRotation:[transformComponent rotation]];
	}
	else
	{
		NSMutableArray *teleportInfosToRemove = [NSMutableArray array];
		for (TeleportInfo *teleportInfo in [teleportComponent teleportInfos])
		{
			if ([teleportInfo hasCountdownReachedZero])
			{
				[EntityUtil setEntityPosition:[teleportInfo entity] position:[teleportComponent outPosition]];

				PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:[teleportInfo entity]];
				float velocityLength = ccpLength([[physicsComponent body] vel]);
				float angle = [Utils cocos2dDegreesToChipmunkRadians:[teleportComponent outRotation]];
				cpVect newVelocity;
				newVelocity.x = velocityLength * cosf(angle);
				newVelocity.y = velocityLength * sinf(angle);
				[[physicsComponent body] setVel:newVelocity];

				[physicsComponent enable];
				[[RenderComponent getFrom:[teleportInfo entity]] show];
				[[teleportInfo entity] refresh];

				[teleportInfosToRemove addObject:teleportInfo];
			}
			else
			{
				[teleportInfo decreaseCountdown];
			}
		}
		[[teleportComponent teleportInfos] removeObjectsInArray:teleportInfosToRemove];
	}
}

@end
