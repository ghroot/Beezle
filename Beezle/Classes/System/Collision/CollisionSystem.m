//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "Collision.h"
#import "CollisionComponent.h"
#import "CollisionType.h"
#import "CrumbleComponent.h"
#import "DozerComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "GateComponent.h"
#import "KeyComponent.h"
#import "LevelSession.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PollenComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundComponent.h"
#import "TransformComponent.h"
#import "WoodComponent.h"

#define VELOCITY_TIMES_MASS_FOR_SOUND 80.0f

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_levelSession = levelSession;
	}
	return self;
}

-(id) init
{
    self = [self initWithLevelSession:nil];
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
	Entity *firstEntity = [collision firstEntity];
    Entity *secondEntity = [collision secondEntity];
	
	BOOL continueProcessingCollision = TRUE;
	
	// Collision
	if ([firstEntity hasComponent:[CollisionComponent class]])
	{
		CollisionComponent *collisionComponent = [CollisionComponent getFrom:firstEntity];
		if ([collisionComponent destroyEntityOnCollision])
		{
			[EntityUtil destroyEntity:firstEntity];
		}
		if ([collisionComponent destroyCollidingEntityOnCollision])
		{
			[EntityUtil destroyEntity:secondEntity];
		}
		if ([collisionComponent collisionSpawnEntityType] != nil)
		{
			Entity *spawnedEntity = [EntityFactory createEntity:[collisionComponent collisionSpawnEntityType] world:_world];
			TransformComponent *transformComponent = [TransformComponent getFrom:firstEntity];
			[EntityUtil setEntityPosition:spawnedEntity position:[transformComponent position]];
			[EntityUtil destroyEntity:spawnedEntity];
		}
	}
	if ([secondEntity hasComponent:[CollisionComponent class]])
	{
		CollisionComponent *collisionComponent = [CollisionComponent getFrom:secondEntity];
		if ([collisionComponent destroyEntityOnCollision])
		{
			[EntityUtil destroyEntity:secondEntity];
		}
		if ([collisionComponent destroyCollidingEntityOnCollision])
		{
			[EntityUtil destroyEntity:firstEntity];
		}
		if ([collisionComponent collisionSpawnEntityType] != nil)
		{
			Entity *spawnedEntity = [EntityFactory createEntity:[collisionComponent collisionSpawnEntityType] world:_world];
			TransformComponent *transformComponent = [TransformComponent getFrom:secondEntity];
			[EntityUtil setEntityPosition:spawnedEntity position:[transformComponent position]];
			[EntityUtil destroyEntity:spawnedEntity];
		}
	}
	
    // Dozer / Crumble
	if ([firstEntity hasComponent:[DozerComponent class]] &&
		[secondEntity hasComponent:[CrumbleComponent class]])
	{
		[EntityUtil destroyEntity:secondEntity];
		continueProcessingCollision = FALSE;
	}
	if ([secondEntity hasComponent:[DozerComponent class]] &&
			 [firstEntity hasComponent:[CrumbleComponent class]])
	{
		[EntityUtil destroyEntity:firstEntity];
		continueProcessingCollision = FALSE;
	}
	
    // Pollen / Key
	if ([firstEntity hasComponent:[PollenComponent class]] ||
		[firstEntity hasComponent:[KeyComponent class]])
	{
		[_levelSession consumedEntity:firstEntity];
	}
	if ([secondEntity hasComponent:[PollenComponent class]] ||
			 [secondEntity hasComponent:[KeyComponent class]])
	{
		[_levelSession consumedEntity:secondEntity];
	}
	
    // Sound
	if ([firstEntity hasComponent:[SoundComponent class]])
	{
		if ([collision firstEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
		{
			[EntityUtil playDefaultCollisionSound:firstEntity];
		}
	}
	if ([secondEntity hasComponent:[SoundComponent class]])
	{
		if ([collision secondEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
		{
			[EntityUtil playDefaultCollisionSound:secondEntity];
		}
	}
	
    // Gate
	if ([firstEntity hasComponent:[GateComponent class]])
	{
		GateComponent *gateComponent = [GateComponent getFrom:firstEntity];
		if ([gateComponent isOpened])
		{
			[_levelSession setDidUseKey:TRUE];
			
			// Game notification
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:nil];
		}
	}
	if ([secondEntity hasComponent:[GateComponent class]])
	{
		GateComponent *gateComponent = [GateComponent getFrom:secondEntity];
		if ([gateComponent isOpened])
		{
			[_levelSession setDidUseKey:TRUE];
			
			// Game notification
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:nil];
		}
	}
	
    // Beeater
	if ([firstEntity hasComponent:[BeeComponent class]] &&
		[secondEntity hasComponent:[BeeaterComponent class]])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:firstEntity];
		if ([beeComponent killsBeeaters])
		{
			[beeComponent decreaseBeeaterHitsLeft];
			if ([beeComponent isOutOfBeeaterKills])
			{
				[EntityUtil destroyEntity:firstEntity];
			}
			[EntityUtil destroyEntity:secondEntity];
		}
	}
	if ([secondEntity hasComponent:[BeeComponent class]] &&
		[firstEntity hasComponent:[BeeaterComponent class]])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:secondEntity];
		if ([beeComponent killsBeeaters])
		{
			[beeComponent decreaseBeeaterHitsLeft];
			if ([beeComponent isOutOfBeeaterKills])
			{
				[EntityUtil destroyEntity:secondEntity];
			}
			[EntityUtil destroyEntity:firstEntity];
		}
	}
	
    // Wood
	if ([firstEntity hasComponent:[BeeComponent class]] &&
		[secondEntity hasComponent:[WoodComponent class]])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:firstEntity];
		WoodComponent *woodComponent = [WoodComponent getFrom:secondEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
			[EntityUtil destroyEntity:firstEntity instant:TRUE];
			
			PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:secondEntity];
			int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision secondShape]];
			[woodComponent setShapeIndexAtCollision:shapeIndexAtCollision];
			[EntityUtil destroyEntity:secondEntity];
		}
	}
	if ([secondEntity hasComponent:[BeeComponent class]] &&
		[firstEntity hasComponent:[WoodComponent class]])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:secondEntity];
		WoodComponent *woodComponent = [WoodComponent getFrom:firstEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
			[EntityUtil destroyEntity:secondEntity instant:TRUE];
			
			PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:firstEntity];
			int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision firstShape]];
			[woodComponent setShapeIndexAtCollision:shapeIndexAtCollision];
			[EntityUtil destroyEntity:firstEntity];
		}
	}
	
	return continueProcessingCollision;
}

@end
