//
//  TeleportInSprite.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/12/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportInSprite.h"

@implementation TeleportInSprite

-(void) draw
{
	ccDrawColor4F(0.0f, 255.0f, 0.0f, 1.0f);

	ccDrawCircle(CGPointZero, 16.0f, 0, 20, FALSE);

	float distance = 15.0f * cosf(CC_DEGREES_TO_RADIANS(45.0f));
	ccDrawLine(CGPointMake(-distance, -distance), CGPointMake(distance, distance));
	ccDrawLine(CGPointMake(-distance, distance), CGPointMake(distance, -distance));
}

@end
