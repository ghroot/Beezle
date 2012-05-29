//
//  MovementSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementSystem.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "MovementComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface MovementSystem()

-(CGPoint) getCurrentPosition:(Entity *)entity;
-(CGPoint) getNextPosition:(Entity *)entity;
-(CGPoint) calculateVelocityTowardsNextPosition:(Entity *)entity;
-(BOOL) isAtNextPosition:(Entity *)entity;
-(void) updateNextPosition:(Entity *)entity;
-(void) moveTowardsNextPosition:(Entity *)entity;
-(void) handleEntityFrozen:(NSNotification *)notification;
-(void) handleEntityUnfrozen:(NSNotification *)notification;

@end

@implementation MovementSystem

-(id) init
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [MovementComponent class], [PhysicsComponent class], nil]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_FROZEN withSelector:@selector(handleEntityFrozen:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_UNFROZEN withSelector:@selector(handleEntityUnfrozen:)];
	}
	return self;
}

-(void) dealloc
{
	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) entityAdded:(Entity *)entity
{
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	MovementComponent *movementComponent = [MovementComponent getFrom:entity];
    
    EditComponent *editComponent = [EditComponent getFrom:entity];
    if (editComponent != nil)
    {
        // Create movement indicator entities to allow for editing
        EditComponent *currentEditComponent = editComponent;
        for (NSValue *movePositionAsValue in [movementComponent positions])
        {
            Entity *movementIndicator = [EntityFactory createMovementIndicator:_world forEntity:entity];
            [EntityUtil setEntityPosition:movementIndicator position:[movePositionAsValue CGPointValue]];
            [currentEditComponent setNextMovementIndicatorEntity:movementIndicator];
            [currentEditComponent setMainMoveEntity:entity];
            currentEditComponent = [EditComponent getFrom:movementIndicator];
        }
        [currentEditComponent setMainMoveEntity:entity];
    }
    else
    {
        [movementComponent setStartPosition:[transformComponent position]];
    }
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) processEntity:(Entity *)entity
{
	MovementComponent *movementComponent = [MovementComponent getFrom:entity];
    
    EditComponent *editComponent = [EditComponent getFrom:entity];
    if (editComponent != nil)
    {
        NSMutableArray *latestPositions = [NSMutableArray array];
        Entity *currentMovementIndicatorEntity = [editComponent nextMovementIndicatorEntity];
        while (currentMovementIndicatorEntity != nil)
        {
            TransformComponent *currentTransformComponent = [TransformComponent getFrom:currentMovementIndicatorEntity];
            EditComponent *currentEditComponent = [EditComponent getFrom:currentMovementIndicatorEntity];
            
			[latestPositions addObject:[NSValue valueWithCGPoint:[currentTransformComponent position]]];
            
            currentMovementIndicatorEntity = [currentEditComponent nextMovementIndicatorEntity];
        }
        [movementComponent setPositions:latestPositions];
    }
    else
    {
        if ([movementComponent isMovingPaused] ||
			[[movementComponent positions] count] == 0)
        {
            return;
        }
        
        if ([self isAtNextPosition:entity])
        {
            [self updateNextPosition:entity];
        }
        else
        {
            [self moveTowardsNextPosition:entity];
        }
    }
}

-(CGPoint) getCurrentPosition:(Entity *)entity
{
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	return [transformComponent position];
}

-(CGPoint) getNextPosition:(Entity *)entity
{
	MovementComponent *movementComponent = [MovementComponent getFrom:entity];
	if ([movementComponent isMovingTowardsStartPosition])
	{
		return [movementComponent startPosition];
	}
	else
	{
		NSValue *nextPositionAsValue = [[movementComponent positions] objectAtIndex:[movementComponent currentPositionIndex]];
		return [nextPositionAsValue CGPointValue];
	}
}

-(CGPoint) calculateVelocityTowardsNextPosition:(Entity *)entity
{
	CGPoint currentPosition = [self getCurrentPosition:entity];
	CGPoint nextPosition = [self getNextPosition:entity];
	float moveSpeed = 0.5f;
	if (ccpDistance(currentPosition, nextPosition) < moveSpeed)
	{
		return ccpSub(nextPosition, currentPosition);
	}
	else
	{
		float angle = ccpToAngle(ccpSub(nextPosition, currentPosition));
		return CGPointMake(cosf(angle) * moveSpeed, sinf(angle) * moveSpeed);
	}
}

-(BOOL) isAtNextPosition:(Entity *)entity
{
	CGPoint currentPosition = [self getCurrentPosition:entity];
	CGPoint nextPosition = [self getNextPosition:entity];
	return CGPointEqualToPoint(currentPosition, nextPosition);
}

-(void) updateNextPosition:(Entity *)entity
{
	MovementComponent *movementComponent = [MovementComponent getFrom:entity];
	
	if ([movementComponent isMovingTowardsStartPosition])
	{
		[movementComponent setIsMovingTowardsStartPosition:FALSE];
		[movementComponent setCurrentPositionIndex:0];
		[movementComponent setIsMovingForwardInPositionList:TRUE];
	}
	else
	{
		if ([movementComponent isMovingForwardInPositionList])
		{
			if ([movementComponent currentPositionIndex] == [[movementComponent positions] count] - 1)
			{
				if ([[movementComponent positions] count] == 1)
				{
					[movementComponent setIsMovingTowardsStartPosition:TRUE];
				}
				else
				{
					[movementComponent setIsMovingForwardInPositionList:FALSE];
					[movementComponent setCurrentPositionIndex:[[movementComponent positions] count] - 2];
				}
			}
			else
			{
				[movementComponent setCurrentPositionIndex:[movementComponent currentPositionIndex] + 1];
			}
		}
		else
		{
			if ([movementComponent currentPositionIndex] == 0)
			{
				[movementComponent setIsMovingTowardsStartPosition:TRUE];
			}
			else
			{
				[movementComponent setCurrentPositionIndex:[movementComponent currentPositionIndex] - 1];
			}
		}
	}
}

-(void) moveTowardsNextPosition:(Entity *)entity
{
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	MovementComponent *movementComponent = [MovementComponent getFrom:entity];
	
	CGPoint currentPosition = [self getCurrentPosition:entity];
	CGPoint velocity = [self calculateVelocityTowardsNextPosition:entity];
	
	ChipmunkBody *body = [physicsComponent body];
	[body setPos:CGPointMake(currentPosition.x + velocity.x, currentPosition.y + velocity.y)];
    [body setVel:cpvmult(velocity, 1.0f / FIXED_TIMESTEP)];
	
	if ([movementComponent alwaysFaceForward])
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		if (velocity.x < 0)
		{
			[transformComponent setScale:CGPointMake(abs([transformComponent scale].x), [transformComponent scale].y)];
		}
		else
		{
			[transformComponent setScale:CGPointMake(-abs([transformComponent scale].x), [transformComponent scale].y)];
		}
	}
}

-(void) handleEntityFrozen:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[MovementComponent class]])
	{
		MovementComponent *movementComponent = [MovementComponent getFrom:entity];
		[movementComponent setIsMovingPaused:TRUE];
	}
}

-(void) handleEntityUnfrozen:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[MovementComponent class]])
	{
		MovementComponent *movementComponent = [MovementComponent getFrom:entity];
		[movementComponent setIsMovingPaused:FALSE];
	}
}

@end
