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

@end
