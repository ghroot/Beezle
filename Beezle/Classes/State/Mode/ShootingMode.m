//
//  ShootingMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShootingMode.h"
#import "AimingMode.h"
#import "EntityUtil.h"
#import "GameRulesSystem.h"
#import "LevelCompleteMode.h"
#import "LevelFailedMode.h"

@implementation ShootingMode

@synthesize aimingMode = _aimingMode;
@synthesize levelCompletedMode = _levelCompletedMode;
@synthesize levelFailedMode = _levelFailedMode;

-(id) initWithWorld:(World *)world
{
    if (self = [super initWithWorld:world])
    {
        _gameRulesSystem = (GameRulesSystem *)[[world systemManager] getSystem:[GameRulesSystem class]];
    }
    return self;
}

-(GameMode *) nextMode
{
    if ([_gameRulesSystem isLevelCompleted])
    {
        return _levelCompletedMode;
    }
    else if ([_gameRulesSystem isLevelFailed])
    {
        return _levelFailedMode;
    }
    
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
    if (!isBeeFlying)
    {
        return _aimingMode;
    }
    
    return nil;
}

@end
