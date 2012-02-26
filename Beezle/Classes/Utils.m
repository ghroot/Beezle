//
//  Utils.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

#define TWO_PI 0.0174532925f

@interface Utils()

+(NSArray *) stringToFloats:(NSString *)string;

@end

@implementation Utils

+(NSArray *) stringToFloats:(NSString *)string
{
	NSString *modifiedString = string;
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" }" withString:@""];
	return [modifiedString componentsSeparatedByString:@","];
}

+(CGPoint) stringToPoint:(NSString *)string
{
    NSArray *array = [self stringToFloats:string];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

+(NSString *) pointToString:(CGPoint)point
{
	return [NSString stringWithFormat:@"{ %.2f, %.2f }", point.x, point.y];
}

+(CGSize) stringToSize:(NSString *)string
{
	NSArray *array = [self stringToFloats:string];
    return CGSizeMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

+(NSString *) sizeToString:(CGSize)size
{
	return [NSString stringWithFormat:@"{ %.2f, %.2f }", size.width, size.height];
}

+(cpVect) createVectorWithRandomAngleAndLengthBetween:(int)minLength and:(int)maxLength
{
	int velocityLength = minLength + (rand() % (maxLength - minLength));
	int velocityAngle = CC_DEGREES_TO_RADIANS(rand() % 360);
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

@end
