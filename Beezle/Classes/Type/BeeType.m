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
@dynamic shootSoundName;

GANDENUM(BEE, 0, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SlingerBee", @"shootSoundName", @"", @"freedSoundName")
GANDENUM(SAWEE, 1, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SlingerSawee", @"shootSoundName", @"", @"freedSoundName")
GANDENUM(SPEEDEE, 2, [NSNumber numberWithInt:2], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.4f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SpeedeeSound", @"shootSoundName", @"", @"freedSoundName")
GANDENUM(BOMBEE, 3, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:180000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.7f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:FALSE], @"doesExpire", @"SlingerBombee", @"shootSoundName", @"", @"freedSoundName")
GANDENUM(SUMEE, 4, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:15000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.6f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SlingerSumee", @"shootSoundName", @"", @"freedSoundName")
GANDENUM(TBEE, 5, [NSNumber numberWithInt:1], @"beeaterHits", [NSNumber numberWithBool:TRUE], @"canBeReused", [NSNumber numberWithInt:10000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SlingerTBee", @"shootSoundName", @"FreedTBee", @"freedSoundName")
GANDENUM(MUMEE, 6, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:180000], @"autoDestroyDelay", [NSNumber numberWithFloat:0.2f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:FALSE], @"doesExpire", nil, @"shootSoundName", @"FreedMumee", @"freedSoundName")
GANDENUM(BURNEE, 7, [NSNumber numberWithInt:0], @"beeaterHits", [NSNumber numberWithBool:FALSE], @"canBeReused", [NSNumber numberWithInt:15000], @"autoDestroyDelay", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier", [NSNumber numberWithBool:TRUE], @"doesExpire", @"SlingerBee", @"shootSoundName", @"", @"freedSoundName")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end
