//
//  EntityUtil.m
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityUtil.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
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

+(void) explodeBee:(Entity *)beeEntity
{
	// Crash animation (and delete entity at end of animation)
	RenderComponent *beeRenderComponent = (RenderComponent *)[beeEntity getComponent:[RenderComponent class]];
	[beeRenderComponent playAnimation:@"Bee-Crash" withCallbackTarget:beeEntity andCallbackSelector:@selector(deleteEntity)];
	
	// Disable physics component
	PhysicsComponent *beePhysicsComponent = (PhysicsComponent *)[beeEntity getComponent:[PhysicsComponent class]];
	[beePhysicsComponent disable];
	[beeEntity refresh];
}

+(void) explodeRamp:(Entity *)rampEntity
{
	// Crash animation (and delete entity at end of animation)
	RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
	[rampRenderComponent playAnimation:@"Ramp-Crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
}

+(void) explodeBeeater:(Entity *)beeaterEntity
{
	RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
	RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"body"];
	RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"head"];
	TransformComponent *beeaterTransformComponent = (TransformComponent *)[beeaterEntity getComponent:[TransformComponent class]];
	
	[beeaterTransformComponent setScale:CGPointMake(1.0f, 1.0f)];
	[beeaterHeadRenderSprite hide];
	[beeaterBodyRenderSprite playAnimation:@"Beeater-Body-Destroy" withCallbackTarget:beeaterEntity andCallbackSelector:@selector(deleteEntity)];
}

+(void) explodePollen:(Entity *)pollenEntity
{
	RenderComponent *pollenRenderComponent = (RenderComponent *)[pollenEntity getComponent:[RenderComponent class]];
	[pollenRenderComponent playAnimation:@"Pollen-Pickup" withCallbackTarget:pollenEntity andCallbackSelector:@selector(deleteEntity)];
}

+(void) explodeWood:(Entity *)woodEntity
{
	RenderComponent *woodRenderComponent = (RenderComponent *)[woodEntity getComponent:[RenderComponent class]];
	[woodRenderComponent playAnimation:@"Wood-Destroy" withCallbackTarget:woodEntity andCallbackSelector:@selector(deleteEntity)];
}

+(void) explodeNut:(Entity *)nutEntity
{
	RenderComponent *nutRenderComponent = (RenderComponent *)[nutEntity getComponent:[RenderComponent class]];
	[nutRenderComponent playAnimation:@"Nut-Collect" withCallbackTarget:nutEntity andCallbackSelector:@selector(deleteEntity)];
}

+(void) bounceMushroom:(Entity *)mushroomEntity
{
	RenderComponent *mushroomRenderComponent = (RenderComponent *)[mushroomEntity getComponent:[RenderComponent class]];
	[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
}

@end
