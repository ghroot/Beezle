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
@dynamic doesExpire;

GANDENUM(BEE, 0, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire")
GANDENUM(SAWEE, 1, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire")
GANDENUM(SPEEDEE, 2, [NSNumber numberWithInt:2], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.4f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire")
GANDENUM(BOMBEE, 3, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithInt:180000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.7f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:FALSE], @"doesExpire")
GANDENUM(BOUNCEE, 4, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.2f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire")
GANDENUM(SUMEE, 5, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithInt:15000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.6f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end