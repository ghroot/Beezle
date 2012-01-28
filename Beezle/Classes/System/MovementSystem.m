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

@implementation MovementSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[MovementComponent class], [PhysicsComponent class], nil]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	MovementComponent *movementComponent = (MovementComponent *)[entity getComponent:[MovementComponent class]];
	PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	ChipmunkBody *body = [physicsComponent body];
	cpVect currentPos = [body pos];
	
	float xVel = 0.0f;
	float yVel = 0.0f;
	NSValue *val = [[movementComponent points] objectAtIndex:[movementComponent currentPointIndex]];
	CGPoint nextPosition = [val CGPointValue];
	if (abs(currentPos.x - nextPosition.x) < 0.5f)
	{
		xVel = nextPosition.x - currentPos.x;
	}
	else if (currentPos.x < nextPosition.x)
	{
		xVel = 0.5f;
	}
	else if (currentPos.x > nextPosition.y)
	{
		xVel = -0.5f;
	}
	if (abs(currentPos.y - nextPosition.y) < 0.5f)
	{
		yVel = nextPosition.y - currentPos.y;
	}
	else if (currentPos.y < nextPosition.y)
	{
		yVel = 0.5f;
	}
	else if (currentPos.y > nextPosition.y)
	{
		yVel = -0.5f;
	}
	
	[body setPos:cpv(currentPos.x + xVel, currentPos.y + yVel)];
	[body setVel:cpv(xVel, yVel)];
	
	if ([body pos].x == nextPosition.x &&
		[body pos].y == nextPosition.y)
	{
		[movementComponent setCurrentPointIndex:[movementComponent currentPointIndex] + 1];
		if ([movementComponent currentPointIndex] >= [[movementComponent points] count])
		{
			[movementComponent setCurrentPointIndex:0];
		}
	}
}

@end
