//
//  BeeHandler.m
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeHandler.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "BeeaterComponent.h"
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
#import "PollenComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "WaterComponent.h"
#import "WoodComponent.h"

#define VELOCITY_TIMES_MASS_FOR_SOUND 80.0f

@implementation BeeHandler

+(id) handlerWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	return [[[self alloc] initWithWorld:world andLevelSession:levelSession] autorelease];
}

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
    {
		_world = world;
        _levelSession = levelSession;
    }
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *otherEntity = [collision secondEntity];
	
	BOOL continueProcessingCollision = TRUE;
	
	CollisionComponent *collisionComponent = [CollisionComponent getFrom:otherEntity];
	if ([collisionComponent disposeEntityOnCollision])
	{
		[EntityUtil setEntityDisposed:otherEntity];
	}
	if ([collisionComponent disposeAnimateAndDeleteEntityOnCollision])
	{
		[EntityUtil setEntityDisposed:otherEntity];
		[EntityUtil animateAndDeleteEntity:otherEntity];
	}
	if ([collisionComponent disposeAndDeleteBeeOnCollision])
	{
		[EntityUtil setEntityDisposed:beeEntity];
		[beeEntity deleteEntity];
	}
	if ([collisionComponent disposeAnimateAndDeleteBeeOnCollision])
	{
		[EntityUtil setEntityDisposed:beeEntity];
		[EntityUtil animateAndDeleteEntity:beeEntity];
	}
	if ([collisionComponent collisionAnimationName] != nil)
	{
		RenderComponent *renderComponent = [RenderComponent getFrom:otherEntity];
		NSString *idleAnimationName = [[renderComponent firstRenderSprite] randomDefaultIdleAnimationName];
		[renderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:[collisionComponent collisionAnimationName], idleAnimationName, nil]];
	}
	
	if ([beeEntity hasComponent:[DozerComponent class]] &&
		[otherEntity hasComponent:[CrumbleComponent class]])
	{
		[EntityUtil setEntityDisposed:otherEntity];
		continueProcessingCollision = FALSE;
	}
	
	if ([otherEntity hasComponent:[PollenComponent class]] ||
		[otherEntity hasComponent:[KeyComponent class]])
	{
		[_levelSession consumedEntity:otherEntity];
	}
	
	if ([otherEntity hasComponent:[SoundComponent class]])
	{
		if ([collision firstEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
		{
			[EntityUtil playDefaultCollisionSound:otherEntity];
		}
	}
	
	if ([otherEntity hasComponent:[GateComponent class]])
	{
		GateComponent *gateComponent = [GateComponent getFrom:otherEntity];
		if ([gateComponent isOpened])
		{
			[_levelSession setDidUseKey:TRUE];
			
			// Game notification
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:nil];
		}
	}
	
	if ([otherEntity hasComponent:[BeeaterComponent class]])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		if ([beeComponent killsBeeaters])
		{
			[beeComponent decreaseBeeaterHitsLeft];
			if ([beeComponent isOutOfBeeaterKills])
			{
				[EntityUtil animateAndDeleteEntity:beeEntity];
			}
			
			[EntityUtil setEntityDisposed:otherEntity];
		}
	}
	
	if ([otherEntity hasComponent:[WoodComponent class]])
	{
		WoodComponent *woodComponent = [WoodComponent getFrom:otherEntity];
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
			[beeEntity deleteEntity];
			
			PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:otherEntity];
			int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision secondShape]];
			[woodComponent setShapeIndexAtCollision:shapeIndexAtCollision];
			[EntityUtil setEntityDisposed:otherEntity];
		}
	}
	
	if ([otherEntity hasComponent:[WaterComponent class]])
	{
		WaterComponent *waterComponent = [WaterComponent getFrom:otherEntity];
		
		Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Bees-Animations.plist"];
		TransformComponent *beeTransformComponent = [TransformComponent getFrom:beeEntity];
		[EntityUtil setEntityPosition:splashEntity position:[beeTransformComponent position]];
		[EntityUtil animateAndDeleteEntity:splashEntity animationName:[waterComponent splashAnimationName]];	

	}
	
	return continueProcessingCollision;
}

@end
