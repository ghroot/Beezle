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
		[transformComponent setScale:CGPointMake(-abs([transformComponent scale].x), [transformComponent scale].y)];
	}
	else
	{
		[transformComponent setScale:CGPointMake(abs([transformComponent scale].x), [transformComponent scale].y)];
	}
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

+(void) setEntityUndisposed:(Entity *)entity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
    if (disposableComponent == nil)
    {
        NSLog(@"WARNING: Trying to undispose an entity that is not disposable");
    }
	if ([disposableComponent isDisposed])
	{
		[disposableComponent setIsDisposed:FALSE];
	}
}

+(void) destroyEntity:(Entity *)entity instant:(BOOL)instant
{
	if ([self isEntityDisposable:entity])
	{
        if (instant)
        {
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
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	[defaultRenderSprite playAnimationOnce:animationName andCallBlockAtEnd:^{
		[entity deleteEntity];
	}];
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
		NSMutableArray *actions = [[NSMutableArray alloc] initWithObjects:[CCFadeOut actionWithDuration:duration], nil];
		if (renderSprite == [[renderComponent renderSprites] objectAtIndex:0])
		{
			// Let the first render sprite take care of the entity deletion at the end of the fadeout
			[actions addObject:[CCCallFunc actionWithTarget:entity selector:@selector(deleteEntity)]];
		}
		[[renderSprite sprite] runAction:[CCSequence actionsWithArray:actions]];
		[actions release];
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

@end
