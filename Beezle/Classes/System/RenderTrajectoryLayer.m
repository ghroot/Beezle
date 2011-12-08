//
//  RenderTrajectoryLayer.h
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderTrajectoryLayer.h"

#define GRANULARITY 20
#define MAX_TOTAL_LINE_LENGTH 120

@implementation RenderTrajectoryLayer

@synthesize startPoint = _startPoint;
@synthesize startVelocity = _startVelocity;
@synthesize gravity = _gravity;

-(void) draw
{
	if (_startVelocity.x != 0 || _startVelocity.y != 0)
	{
		CGPoint currentPoint = CGPointMake(_startPoint.x, _startPoint.y);
		CGPoint currentVelocity = CGPointMake(_startVelocity.x, _startVelocity.y);
        float totalLineLength = 0;
		while (totalLineLength < MAX_TOTAL_LINE_LENGTH)
		{
            CGPoint nextPoint = CGPointMake(currentPoint.x + currentVelocity.x / GRANULARITY, currentPoint.y + currentVelocity.y / GRANULARITY);
            
            int alpha = 255 - ((totalLineLength / MAX_TOTAL_LINE_LENGTH) * 255);
            ccDrawColor4B(255,0,0,alpha);
            ccDrawLine(currentPoint, nextPoint);
            
			currentVelocity.x += _gravity.x / GRANULARITY;
			currentVelocity.y += _gravity.y / GRANULARITY;
			
            totalLineLength += ccpDistance(currentPoint, nextPoint);
			currentPoint = nextPoint;
		}
	}
}

@end
