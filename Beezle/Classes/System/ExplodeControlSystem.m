//
//  ExplodeControlSystem.m
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplodeControlSystem.h"
#import "CrumbleComponent.h"
#import "ExplodeComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderSprite.h"
#import "RenderComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"

@interface ExplodeControlSystem()

-(BOOL) doesExplodedEntity:(Entity *)explodedEntity intersectCrumbleEntity:(Entity *)crumbleEntity;
-(void) startExplode:(Entity *)entity;
-(void) endExplode:(Entity *)entity;

@end

@implementation ExplodeControlSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[ExplodeComponent class], [RenderComponent class], nil]];
    return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) processEntity:(Entity *)entity
{
    while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
		if ([nextInputAction touchType] == TOUCH_BEGAN)
		{
			ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
			if (![explodeComponent hasExploded])
			{
				[explodeComponent setHasExploded:TRUE];
				[self startExplode:entity];
			}
		}
	}
}

-(BOOL) doesExplodedEntity:(Entity *)explodedEntity intersectCrumbleEntity:(Entity *)crumbleEntity
{
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:explodedEntity];
	TransformComponent *explodedTransformComponent = [TransformComponent getFrom:explodedEntity];
	int left = [explodedTransformComponent position].x - [explodeComponent radius];
	int right = [explodedTransformComponent position].x + [explodeComponent radius];
	int top = [explodedTransformComponent position].y + [explodeComponent radius];
	int bottom = [explodedTransformComponent position].y - [explodeComponent radius];
	cpBB explosionBB = cpBBNew(left, bottom, right, top);
	
	PhysicsComponent *crumblePhysicsComponent = [PhysicsComponent getFrom:crumbleEntity];	
	cpBB otherBB = [[crumblePhysicsComponent firstPhysicsShape] bb];
	for (int i = 1; i < [[crumblePhysicsComponent shapes] count]; i++)
	{
		cpBB shapeBB = [[[crumblePhysicsComponent shapes] objectAtIndex:i] bb];
		otherBB = cpBBMerge(otherBB, shapeBB);
	}
	
	return cpBBIntersects(explosionBB, otherBB);
}

-(void) startExplode:(Entity *)entity
{
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSprite *renderSprite = [renderComponent firstRenderSprite];
	[renderSprite playAnimation:[explodeComponent explodeStartAnimationName] withCallbackTarget:self andCallbackSelector:@selector(endExplode:) object:entity];
	
	// Uncomment if rotation should stop
//	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
//	[[physicsComponent body] setAngVelLimit:0.0f];
}

-(void) endExplode:(Entity *)entity
{
	[EntityUtil setEntityDisposed:entity];
	
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
	[EntityUtil animateAndDeleteEntity:entity animationName:[explodeComponent explodeEndAnimationName]];
	
	for (Entity *otherEntity in [[_world entityManager] entities])
	{
		if ([otherEntity hasComponent:[CrumbleComponent class]])
		{
			if ([self doesExplodedEntity:entity intersectCrumbleEntity:otherEntity])
			{
				if (![EntityUtil isEntityDisposed:otherEntity])
				{
					[EntityUtil setEntityDisposed:otherEntity];
				}
			}
		}
	}
	
	[[SoundManager sharedManager] playSound:@"BombeeBoom"];
}

@end
