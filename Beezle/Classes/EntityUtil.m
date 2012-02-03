//
//  EntityUtil.m
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityUtil.h"
#import "BeeaterComponent.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
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

+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName disablePhysics:(BOOL)disablePhysics
{
	RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
	[renderComponent playAnimation:animationName withCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
	if (disablePhysics)
	{
		PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
		[physicsComponent disable];
		[entity refresh];
	}
}

+(void) animateDeleteAndSaveBeeFromBeeaterEntity:(Entity *)beeaterEntity
{
	// Save bee
	TagManager *tagManager = (TagManager *)[[beeaterEntity world] getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	BeeaterComponent *beeaterComponent = (BeeaterComponent *)[beeaterEntity getComponent:[BeeaterComponent class]];
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	[slingerComponent pushBeeType:[beeaterComponent containedBeeType]];
	
	// Destroy beeater
	TransformComponent *beeaterTransformComponent = (TransformComponent *)[beeaterEntity getComponent:[TransformComponent class]];
	RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
	RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"body"];
	RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"head"];
	[beeaterTransformComponent setScale:CGPointMake(1.0f, 1.0f)];
	[beeaterHeadRenderSprite hide];
	[beeaterBodyRenderSprite playAnimation:@"Beeater-Body-Destroy" withCallbackTarget:beeaterEntity andCallbackSelector:@selector(deleteEntity)];
	
	// Game notification
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[beeaterTransformComponent position]] forKey:@"beeaterEntityPosition"];
	[notificationUserInfo setObject:[beeaterComponent containedBeeType] forKey:@"beeType"];
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];
}

@end
