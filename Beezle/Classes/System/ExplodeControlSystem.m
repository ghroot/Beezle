//
//  ExplodeControlSystem.m
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplodeControlSystem.h"
#import "BeeaterComponent.h"
#import "CrumbleComponent.h"
#import "ExplodeComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "TransformComponent.h"

@interface ExplodeControlSystem()

-(BOOL) doesExplodedEntity:(Entity *)explodedEntity intersectCrumbleEntity:(Entity *)crumbleEntity;

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
    if ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
		if ([nextInputAction touchType] == TOUCH_BEGAN)
		{
			BOOL shouldExplode = TRUE;
			if ([entity hasComponent:[DisposableComponent class]])
			{
				DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
				if ([disposableComponent isDisposed])
				{
					shouldExplode = FALSE;
				}
				else
				{
					[disposableComponent setIsDisposed:TRUE];
				}
			}
			
			if (shouldExplode)
			{
				for (Entity *otherEntity in [[_world entityManager] entities])
				{
					if ([otherEntity hasComponent:[CrumbleComponent class]])
					{
						if ([self doesExplodedEntity:entity intersectCrumbleEntity:otherEntity])
						{
							CrumbleComponent *crumbleComponent = [CrumbleComponent getFrom:otherEntity];
							if ([crumbleComponent crumbleAnimationName] != nil)
							{
								[EntityUtil animateAndDeleteEntity:otherEntity animationName:[crumbleComponent crumbleAnimationName] disablePhysics:TRUE];
							}
							else if ([otherEntity hasComponent:[BeeaterComponent class]])
							{
								// TODO: Handle more generically
								NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:otherEntity forKey:@"beeaterEntity"];
								[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEEATER_KILLED object:self userInfo:notificationUserInfo];
							}
							else
							{
								[otherEntity deleteEntity];
							}
						}
					}
				}
				
				ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
				[EntityUtil animateAndDeleteEntity:entity animationName:[explodeComponent explodeAnimationName] disablePhysics:TRUE];
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

@end
