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

@interface MovementSystem()

-(CGPoint) getCurrentPosition:(Entity *)entity;
-(CGPoint) getNextPosition:(Entity *)entity;
-(CGPoint) calculateVelocityTowardsNextPosition:(Entity *)entity;
-(BOOL) isAtNextPosition:(Entity *)entity;
-(void) updateNextPosition:(Entity *)entity;
-(void) moveTowardsNextPosition:(Entity *)entity;

@end

@implementation MovementSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [MovementComponent class], [PhysicsComponent class], nil]];
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
	if ([[movementComponent positions] count] == 0)
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

-(CGPoint) getCurrentPosition:(Entity *)entity
{
	TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
	return [transformComponent position];
}

-(CGPoint) getNextPosition:(Entity *)entity
{
	MovementComponent *movementComponent = (MovementComponent *)[entity getComponent:[MovementComponent class]];
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
	float moveSpeed = 0.8f;
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
	MovementComponent *movementComponent = (MovementComponent *)[entity getComponent:[MovementComponent class]];
	
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
	PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	CGPoint currentPosition = [self getCurrentPosition:entity];
	CGPoint velocity = [self calculateVelocityTowardsNextPosition:entity];
	
	ChipmunkBody *body = [physicsComponent body];
	[body setPos:CGPointMake(currentPosition.x + velocity.x, currentPosition.y + velocity.y)];
	[body setVel:velocity];
}

@end
