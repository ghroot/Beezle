//
//  EntityUtil.m
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionType.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"

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
    return [[DisposableComponent getFrom:entity] isDisposed];
}

+(void) setEntityDisposed:(Entity *)entity deleteEntity:(BOOL)deleteEntity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
	if ([disposableComponent isDisposed])
	{
		NSLog(@"WARNING: Marking already disposed component as disposed again");
	}
	[disposableComponent setIsDisposed:TRUE];
    
    NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
    [[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_DISPOSED object:self userInfo:notificationUserInfo];
	
	if ([disposableComponent deleteEntityWhenDisposed])
	{
		[entity deleteEntity];
	}
}

+(void) setEntityDisposed:(Entity *)entity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
	[self setEntityDisposed:entity deleteEntity:[disposableComponent deleteEntityWhenDisposed]];
}

+(Entity *) getWaterEntity:(World *)world
{
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	return [tagManager getEntity:@"WATER"];
}

+(BOOL) hasWaterEntity:(World *)world
{
	return [self getWaterEntity:world] != nil;
}

+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName disablePhysics:(BOOL)disablePhysics
{
	[[RenderComponent getFrom:entity] playAnimation:animationName withCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
	if (disablePhysics)
	{
		[[PhysicsComponent getFrom:entity] disable];
		[entity refresh];
	}
}

+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName
{
    [self animateAndDeleteEntity:entity animationName:animationName disablePhysics:TRUE];
}

+(void) animateAndDeleteEntity:(Entity *)entity disablePhysics:(BOOL)disablePhysics
{
    [[RenderComponent getFrom:entity] playDefaultDestroyAnimationWithCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
	if (disablePhysics)
	{
		[[PhysicsComponent getFrom:entity] disable];
		[entity refresh];
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
	if ([soundComponent defaultCollisionSoundName])
	{
		[[SoundManager sharedManager] playSound:[[SoundComponent getFrom:entity] defaultCollisionSoundName]];
	}
}

+(void) playDefaultDestroySound:(Entity *)entity
{
	SoundComponent *soundComponent = [SoundComponent getFrom:entity];
	if ([soundComponent defaultCollisionSoundName])
	{
		[[SoundManager sharedManager] playSound:[[SoundComponent getFrom:entity] defaultDestroySoundName]];
	}
}

@end
