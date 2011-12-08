//
//  RenderTrajectoryLayer.h
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderTrajectoryLayer.h"

#define N_POINTS_TO_DRAW 20
#define GRANULARITY 20

@implementation RenderTrajectoryLayer

@synthesize startPoint = _startPoint;
@synthesize startVelocity = _startVelocity;
@synthesize gravity = _gravity;

-(void) draw
{
	if (_startVelocity.x != 0 || _startVelocity.y != 0)
	{
		CGPoint vertices[N_POINTS_TO_DRAW];
		CGPoint currentPoint = CGPointMake(_startPoint.x, _startPoint.y);
		CGPoint currentVelocity = CGPointMake(_startVelocity.x, _startVelocity.y);
		for (int i = 0; i < N_POINTS_TO_DRAW; i++)
		{
			vertices[i] = CGPointMake(currentPoint.x, currentPoint.y);
			
			currentVelocity.x += _gravity.x / GRANULARITY;
			currentVelocity.y += _gravity.y / GRANULARITY;
			
			currentPoint.x += currentVelocity.x / GRANULARITY;
			currentPoint.y += currentVelocity.y / GRANULARITY;
		}
		
        ccDrawColor4f(200.0f, 0.0f, 0.0f, 0.4f);
		ccDrawPoly(vertices, N_POINTS_TO_DRAW, FALSE);
	}
}

@end
