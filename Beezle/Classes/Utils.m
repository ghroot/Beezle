//
//  Utils.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(CGPoint) stringToPoint:(NSString *)string
{
    NSString *modifiedString = string;
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [modifiedString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

+(NSString *) pointToString:(CGPoint)position
{
	return [NSString stringWithFormat:@"{ %.2f, %.2f }", position.x, position.y];
}

@end
