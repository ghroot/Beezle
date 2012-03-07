//
//  AimingMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimingMode.h"
#import "EntityUtil.h"
#import "ShootingMode.h"

@implementation AimingMode

@synthesize shootingMode = _shootingMode;

-(id) initWithWorld:(World *)world
{
    if (self = [super initWithWorld:world])
    {
        // Pick systems
    }
    return self;
}

-(GameMode *) nextMode
{
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *beeEntities = [groupManager getEntitiesInGroup:@"BEES"];
    BOOL isBeeFlying = FALSE;
    for (Entity *beeEntity in beeEntities)
    {
        if (![EntityUtil isEntityDisposed:beeEntity])
        {
            isBeeFlying = TRUE;
        }
    }
    if (isBeeFlying)
    {
        return _shootingMode;
    }
    
    return nil;
}

@end
