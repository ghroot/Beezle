//
//  BeeType.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeType.h"

@implementation BeeType

@dynamic canDestroyWood;
@dynamic slingerShootSpeedModifier;

GANDENUM(BEE, 0, [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier")
GANDENUM(SAWEE, 1, [NSNumber numberWithBool:TRUE], @"canDestroyWood", [NSNumber numberWithFloat:1.0f], @"slingerShootSpeedModifier")
GANDENUM(SPEEDEE, 2, [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithFloat:1.6f], @"slingerShootSpeedModifier")
GANDENUM(BOMBEE, 3, [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithFloat:0.7f], @"slingerShootSpeedModifier")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end
