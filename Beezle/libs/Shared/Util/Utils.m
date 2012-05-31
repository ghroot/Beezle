//
//  Utils.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

#define TWO_PI 0.0174532925f

@implementation Utils

+(cpVect) createVectorWithRandomAngleAndLengthBetween:(float)minLength and:(float)maxLength
{
	float velocityLength = minLength + (rand() % (int)(maxLength - minLength));
	float velocityAngle = CC_DEGREES_TO_RADIANS(rand() % 360);
	cpVect randomVelocity = cpv(velocityLength * cosf(velocityAngle), velocityLength * sinf(velocityAngle));
	return randomVelocity;
}

+(float) unwindAngleDegrees:(float)angle
{
	while (angle < 0)
	{
		angle += 360;
	}
	while (angle >= 360)
	{
		angle -= 360;
	}
	return angle;
}

+(float) unwindAngleRadians:(float)angle
{
	while (angle < 0)
	{
		angle += TWO_PI;
	}
	while (angle >= TWO_PI)
	{
		angle -= TWO_PI;
	}
	return angle;
}

+(CGPoint) getScreenCenterPosition
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	return CGPointMake(winSize.width / 2, winSize.height / 2);
}

@end
