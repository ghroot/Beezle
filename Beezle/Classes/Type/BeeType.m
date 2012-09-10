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
@dynamic canBeReused;
@dynamic autoDestroyDelay;
@dynamic slingerShootSpeedModifier;
@dynamic doesExpire;
@dynamic freedSoundName;

GANDENUM(BEE, 0, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"", @"freedSoundName")
GANDENUM(SAWEE, 1, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"", @"freedSoundName")
GANDENUM(SPEEDEE, 2, [NSNumber numberWithInt:2], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.4f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"", @"freedSoundName")
GANDENUM(BOMBEE, 3, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:180000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.7f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:FALSE], @"doesExpire", @"", @"freedSoundName")
GANDENUM(SUMEE, 4, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:15000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.6f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"", @"freedSoundName")
GANDENUM(TBEE, 5, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:TRUE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"FreedTBee", @"freedSoundName")
GANDENUM(MUMEE, 6, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:180000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.2f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:FALSE], @"doesExpire", @"", @"freedSoundName")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end
