//
//  MovementSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementSystem.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

@implementation MovementSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[MovementComponent class], [PhysicsComponent class], nil]];
	return self;
}

-(void) entityAdded:(Entity *)entity
{
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	MovementComponent *movementComponent = (MovementComponent *)[entity getComponent:[MovementComponent class]];
	
	[movementComponent setStartPosition:[transformComponent position]];
}

-(void) processEntity:(Entity *)entity
{
	MovementComponent *movementComponent = (MovementComponent *)[entity getComponent:[MovementComponent class]];
	PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	if ([[movementComponent positions] count] == 0)
	{
		return;
	}
	
	// Current position
	ChipmunkBody *body = [physicsComponent body];
	cpVect currentPosition = [body pos];
	
	// Next position
	CGPoint nextPosition;
	if ([movementComponent isMovingTowardsStartPosition])
	{
		nextPosition = [movementComponent startPosition];
	}
	else
	{
		NSValue *nextPositionAsValue = [[movementComponent positions] objectAtIndex:[movementComponent currentPositionIndex]];
		nextPosition = [nextPositionAsValue CGPointValue];
	}
	
	// Determine velocity
	float moveSpeed = 0.8f;
	float xVel = 0.0f;
	float yVel = 0.0f;
	if (abs(currentPosition.x - nextPosition.x) < moveSpeed)
	{
		xVel = nextPosition.x - currentPosition.x;
	}
	else if (currentPosition.x < nextPosition.x)
	{
		xVel = moveSpeed;
	}
	else if (currentPosition.x > nextPosition.x)
	{
		xVel = -moveSpeed;
	}
	if (abs(currentPosition.y - nextPosition.y) < moveSpeed)
	{
		yVel = nextPosition.y - currentPosition.y;
	}
	else if (currentPosition.y < nextPosition.y)
	{
		yVel = moveSpeed;
	}
	else if (currentPosition.y > nextPosition.y)
	{
		yVel = -moveSpeed;
	}
	
	// Apply velocity to physics
	[body setPos:cpv(currentPosition.x + xVel, currentPosition.y + yVel)];
	[body setVel:cpv(xVel, yVel)];
	
	// Check if target is hit
	if ([body pos].x == nextPosition.x &&
		[body pos].y == nextPosition.y)
	{
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
}

@end
