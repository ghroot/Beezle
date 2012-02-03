//
//  BeeControlSystem.m
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeControlSystem.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "TransformComponent.h"

@implementation BeeControlSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], nil]];
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
		BeeComponent *beeComponent = [BeeComponent getFrom:entity];
		if ([[beeComponent type] canExplode] &&
			[nextInputAction touchType] == TOUCH_BEGAN)
		{
			LabelManager *labelManager = (LabelManager *)[_world getManager:[LabelManager class]];
			GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
			for (Entity *otherEntity in [[_world entityManager] entities])
			{
				if ([labelManager hasEntity:otherEntity label:@"RAMP"] ||
					[groupManager isEntity:otherEntity inGroup:@"BEEATERS"])
				{
					TransformComponent *transformComponent = [TransformComponent getFrom:entity];
					PhysicsComponent *otherPhysicsComponent = [PhysicsComponent getFrom:otherEntity];
					
					int left = [transformComponent position].x - 30;
					int right = [transformComponent position].x + 30;
					int top = [transformComponent position].y + 30;
					int bottom = [transformComponent position].y - 30;
					cpBB explosionBB = cpBBNew(left, bottom, right, top);
					
					cpBB otherBB = [[otherPhysicsComponent firstPhysicsShape] bb];
					for (int i = 1; i < [[otherPhysicsComponent shapes] count]; i++)
					{
						cpBB shapeBB = [[[otherPhysicsComponent shapes] objectAtIndex:i] bb];
						otherBB = cpBBMerge(otherBB, shapeBB);
					}
					
					if (cpBBIntersects(explosionBB, otherBB))
					{
						if ([labelManager hasEntity:otherEntity label:@"RAMP"])
						{
							[EntityUtil animateAndDeleteEntity:otherEntity animationName:@"Ramp-Crash"];
						}
						else if ([groupManager isEntity:otherEntity inGroup:@"BEEATERS"])
						{
							[EntityUtil animateDeleteAndSaveBeeFromBeeaterEntity:otherEntity];
						}
					}
				}
			}
			
			[EntityUtil animateAndDeleteEntity:entity animationName:@"Bombee-Boom"];
		}
	}
}

@end
