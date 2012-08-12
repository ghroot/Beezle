//
//  TeleportOutSprite.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportOutSprite.h"

@implementation TeleportOutSprite

-(void) draw
{
	ccDrawColor4F(0.0f, 255.0f, 0.0f, 1.0f);

	CGPoint topPoint = CGPointMake(0.0f, 40.0f);
	ccDrawLine(CGPointZero, topPoint);
	ccDrawLine(topPoint, CGPointMake(topPoint.x - 15.0f, topPoint.y - 15.0f));
	ccDrawLine(topPoint, CGPointMake(topPoint.x + 15.0f, topPoint.y - 15.0f));
}

@end
