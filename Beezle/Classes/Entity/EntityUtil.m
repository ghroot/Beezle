//
//  EntityUtil.m
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "WaterComponent.h"
#import "HealthComponent.h"

@implementation EntityUtil

+(void) setEntityPosition:(Entity *)entity position:(CGPoint)position
{
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	[transformComponent setPosition:position];
	
	PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	if (physicsComponent != nil)
	{
		[physicsComponent setPositionManually:position];
	}
}

+(void) setEntityRotation:(Entity *)entity rotation:(float)rotation
{
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	[transformComponent setRotation:rotation];
	
	PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	if (physicsComponent != nil)
	{
		[physicsComponent setRotationManually:rotation];
	}
}

+(void) setEntityMirrored:(Entity *)entity mirrored:(BOOL)mirrored
{
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	
	if (mirrored)
	{
		[transformComponent setScale:CGPointMake(-abs((int)[transformComponent scale].x), [transformComponent scale].y)];
	}
	else
	{
		[transformComponent setScale:CGPointMake(abs((int)[transformComponent scale].x), [transformComponent scale].y)];
	}
}

+(void) disableAllComponents:(Entity *)entity
{
	NSArray *components = [entity getComponents];
	for (Component *component in components)
	{
		[component disable];
	}
	[entity refresh];
}

+(void) enableAllComponents:(Entity *)entity
{
	NSArray *components = [entity getComponents];
	for (Component *component in components)
	{
		[component enable];
	}
	[entity refresh];
}

+(BOOL) isEntityDisposable:(Entity *)entity
{
    return [entity hasComponent:[DisposableComponent class]];
}

+(BOOL) isEntityDisposed:(Entity *)entity
{
    DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
    if (disposableComponent == nil)
    {
        NSLog(@"WARNING: Trying to query disposal status on an entity that is not disposable");
    }
    return [disposableComponent isDisposed];
}

+(void) setEntityDisposed:(Entity *)entity sendNotification:(BOOL)sendNotification
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
    if (disposableComponent == nil)
    {
        NSLog(@"WARNING: Trying to dispose an entity that is not disposable");
    }
	if (![disposableComponent isDisposed])
	{
		[disposableComponent setIsDisposed:TRUE];
    
		if (sendNotification)
		{
			NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_DISPOSED object:self userInfo:notificationUserInfo];
		}
	}
}

+(void) setEntityDisposed:(Entity *)entity
{
	[self setEntityDisposed:entity sendNotification:TRUE];
}

+(void) setEntityIsAboutToBeDeleted:(Entity *)entity
{
	if ([self isEntityDisposable:entity])
	{
		[[DisposableComponent getFrom:entity] setIsAboutToBeDeleted:TRUE];
	}
}

+(void) destroyEntity:(Entity *)entity instant:(BOOL)instant damage:(int)damage
{
	if ([entity hasComponent:[HealthComponent class]])
	{
		HealthComponent *healthComponent = [HealthComponent getFrom:entity];
		for (int i = 0; i < damage; i++)
		{
			[healthComponent deductHealthPoint];
		}
		if ([healthComponent hasHealthPointsLeft])
		{
			RenderComponent *renderComponent = [RenderComponent getFrom:entity];
			for (RenderSprite *renderSprite in [renderComponent renderSprites])
			{
				NSString *hitAnimationName = [healthComponent hitAnimationNameForRenderSpriteName:[renderSprite name]];
				NSString *idleAnimationName = [renderSprite randomDefaultIdleAnimationName];
				[renderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:hitAnimationName, idleAnimationName, nil]];
			}

			NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
			[notificationUserInfo setObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_HIT object:self userInfo:notificationUserInfo];

			return;
		}
	}

	if ([self isEntityDisposable:entity])
	{
		if (instant)
		{
			// Don't send notification so systems like DisposalSystem doesn't pick it up
			[self setEntityDisposed:entity sendNotification:FALSE];
			[entity deleteEntity];
		}
		else
		{
			[self setEntityDisposed:entity];
		}
	}
	else if (!instant &&
			[[RenderComponent getFrom:entity] hasDefaultDestroyAnimation])
	{
		[self animateAndDeleteEntity:entity];
	}
	else
	{
		[entity deleteEntity];
	}

	if (!instant)
	{
		[self playDefaultDestroySound:entity];
	}
}

+(void) destroyEntity:(Entity *)entity instant:(BOOL)instant
{
	[self destroyEntity:entity instant:instant damage:1];
}

+(void) destroyEntity:(Entity *)entity
{
	[self destroyEntity:entity instant:FALSE];
}

+(void) disablePhysics:(Entity *)entity
{
	[[PhysicsComponent getFrom:entity] disable];
	[entity refresh];
}

+(Entity *) getWaterEntity:(World *)world
{
    for (Entity *entity in [[world entityManager] entities])
    {
        if ([entity hasComponent:[WaterComponent class]])
        {
            return entity;
        }
    }
    return nil;
}

+(BOOL) hasWaterEntity:(World *)world
{
	return [self getWaterEntity:world] != nil;
}

+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName disablePhysics:(BOOL)disablePhysics
{
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		if (renderSprite == [[renderComponent renderSprites] lastObject])
		{
			[renderSprite playAnimationOnce:animationName andCallBlockAtEnd:^{
				[entity deleteEntity];
			}];
		}
		else
		{
			[renderSprite playAnimationOnce:animationName];
		}
	}
	if ([self isEntityDisposable:entity])
	{
		[[DisposableComponent getFrom:entity] setIsAboutToBeDeleted:TRUE];
	}
	if (disablePhysics)
	{
		[self disablePhysics:entity];
	}
}

+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName
{
    [self animateAndDeleteEntity:entity animationName:animationName disablePhysics:TRUE];
}

+(void) animateAndDeleteEntity:(Entity *)entity disablePhysics:(BOOL)disablePhysics
{
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	[renderComponent playDefaultDestroyAnimationAndCallBlockAtEnd:^{
		[entity deleteEntity];
	}];
	if ([self isEntityDisposable:entity])
	{
		[[DisposableComponent getFrom:entity] setIsAboutToBeDeleted:TRUE];
	}
	if (disablePhysics)
	{
		[self disablePhysics:entity];
	}
}

+(void) animateAndDeleteEntity:(Entity *)entity
{
    [self animateAndDeleteEntity:entity disablePhysics:TRUE];
}

+(void) fadeOutAndDeleteEntity:(Entity *)entity duration:(float)duration
{
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		NSMutableArray *actions = [NSMutableArray array];
		
		CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:duration];
		[actions addObject:fadeOutAction];
		
		if (renderSprite == [[renderComponent renderSprites] lastObject])
		{
			CCCallBlock *callBlockAction = [CCCallBlock actionWithBlock:^{
				[entity deleteEntity];
			}];
			[actions addObject:callBlockAction];
		}
		
		[[renderSprite sprite] runAction:[CCSequence actionWithArray:actions]];
	}
	if ([self isEntityDisposable:entity])
	{
		[[DisposableComponent getFrom:entity] setIsAboutToBeDeleted:TRUE];
	}
}

+(void) playDefaultCollisionSound:(Entity *)entity
{
	SoundComponent *soundComponent = [SoundComponent getFrom:entity];
	if ([soundComponent hasDefaultCollisionSoundName])
	{
		[[SoundManager sharedManager] playSound:[soundComponent randomDefaultCollisionSoundName]];
	}
}

+(void) playDefaultDestroySound:(Entity *)entity
{
	SoundComponent *soundComponent = [SoundComponent getFrom:entity];
	if ([soundComponent hasDefaultDestroySoundName])
	{
		[[SoundManager sharedManager] playSound:[soundComponent randomDefaultDestroySoundName]];
	}
}

+(CGPoint) getRandomPositionWithinShapes:(NSArray *)shapes boundingBox:(cpBB)boundingBox
{
	CGPoint randomPosition = CGPointZero;
	BOOL validPoint = FALSE;
	while (!validPoint)
	{
		randomPosition = CGPointMake(boundingBox.l + rand() % (int)(boundingBox.r - boundingBox.l), boundingBox.b + rand() % (int)(boundingBox.t - boundingBox.b));
		for (ChipmunkShape *shape in shapes)
		{
			ChipmunkNearestPointQueryInfo *queryInfo = [shape nearestPointQuery:randomPosition];
			if ([queryInfo dist] <= 0)
			{
				validPoint = TRUE;
			}
		}
	}
	return randomPosition;
}

@end
