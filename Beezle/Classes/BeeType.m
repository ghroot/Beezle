//
//  BeeType.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeType.h"

@implementation BeeType

@dynamic canDestroyRamp;
@dynamic canDestroyWood;
@dynamic canExplode;

GANDENUM(BEE, 0, [NSNumber numberWithBool:FALSE], @"canDestroyRamp", [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithBool:FALSE], @"canExplode")
GANDENUM(SAWEE, 1, [NSNumber numberWithBool:FALSE], @"canDestroyRamp", [NSNumber numberWithBool:TRUE], @"canDestroyWood", [NSNumber numberWithBool:FALSE], @"canExplode")
GANDENUM(SPEEDEE, 2,[NSNumber numberWithBool:FALSE], @"canDestroyRamp", [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithBool:FALSE], @"canExplode")
GANDENUM(BOMBEE, 3, [NSNumber numberWithBool:FALSE], @"canDestroyRamp", [NSNumber numberWithBool:FALSE], @"canDestroyWood", [NSNumber numberWithBool:TRUE], @"canExplode")

-(NSString *) capitalizedString
{
    return [name capitalizedString];
}

@end
