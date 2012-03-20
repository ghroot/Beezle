//
//  BeeType.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeType.h"

@implementation BeeType

@dynamic beeaterHits;
@dynamic autoDestroyDelay;
@dynamic slingerShootSpeedModifier;

GANDENUM(BEE, 0, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier")
GANDENUM(SAWEE, 1, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier")
GANDENUM(SPEEDEE, 2, [NSNumber numberWithInt:2], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.3f], @"slingerShootSpeedModifier")
GANDENUM(BOMBEE, 3, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:60000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.7f], @"slingerShootSpeedModifier")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end
