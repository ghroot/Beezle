//
//  Utils.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

static const float TWO_PI = 0.0174532925f;

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

+(float) cocos2dDegreesToChipmunkDegrees:(float)cocos2dDegrees
{
	return [self unwindAngleDegrees:360.0f - cocos2dDegrees + 90.0f];
}

+(float) cocos2dDegreesToChipmunkRadians:(float)cocos2dDegrees
{
	return CC_DEGREES_TO_RADIANS([self cocos2dDegreesToChipmunkDegrees:cocos2dDegrees]);
}

+(float) chipmunkDegreesToCocos2dDegrees:(float)chipmunkDegrees
{
	return [self unwindAngleDegrees:360.0f - chipmunkDegrees + 270.0f];
}

+(float) chipmunkRadiansToCocos2dDegrees:(float)chipmunkRadians
{
	return [self chipmunkDegreesToCocos2dDegrees:CC_RADIANS_TO_DEGREES(chipmunkRadians)];
}

+(CGPoint) screenCenterPosition
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	return CGPointMake(winSize.width / 2, winSize.height / 2);
}

+(CCRenderTexture *) takeScreenShot
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
	[renderTexture begin];
	CCScene *scene = [[CCDirector sharedDirector] runningScene];
	[scene visit];
	[renderTexture end];
	return renderTexture;
}

@end
