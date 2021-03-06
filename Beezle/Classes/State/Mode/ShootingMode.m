//
//  ShootingMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShootingMode.h"
#import "AimingMode.h"
#import "BeeQueueRenderingSystem.h"
#import "EntityUtil.h"
#import "GameplayState.h"
#import "GameRulesSystem.h"
#import "LevelCompletedMode.h"
#import "LevelFailedMode.h"
#import "InAppLayer.h"

@implementation ShootingMode

@synthesize aimingMode = _aimingMode;
@synthesize levelCompletedMode = _levelCompletedMode;
@synthesize levelFailedMode = _levelFailedMode;

-(id) initWithGameplayState:(GameplayState *)gameplayState
{
    if (self = [super initWithGameplayState:gameplayState])
    {
		[_systems addObject:[gameplayState soundSystem]];
		[_systems addObject:[gameplayState movementSystem]];
		[_systems addObject:[gameplayState physicsSystem]];
		[_systems addObject:[gameplayState collisionSystem]];
		[_systems addObject:[gameplayState waterWaveSystem]];
		[_systems addObject:[gameplayState teleportSystem]];
		[_systems addObject:[gameplayState renderSystem]];
		[_systems addObject:[gameplayState hudRenderingSystem]];
		[_systems addObject:[gameplayState inputSystem]];
		[_systems addObject:[gameplayState beeExpirationSystem]];
		[_systems addObject:[gameplayState destroySystem]];
		[_systems addObject:[gameplayState explodeControlSystem]];
		[_systems addObject:[gameplayState followExplodeSystem]];
		[_systems addObject:[gameplayState stingControlSystem]];
		[_systems addObject:[gameplayState destructControlSystem]];
		[_systems addObject:[gameplayState followControlSystem]];
		[_systems addObject:[gameplayState freezeSystem]];
		[_systems addObject:[gameplayState fadeSystem]];
		[_systems addObject:[gameplayState beeaterSystem]];
		[_systems addObject:[gameplayState capturedSystem]];
		[_systems addObject:[gameplayState beeQueueRenderingSystem]];
		[_systems addObject:[gameplayState shardSystem]];
		[_systems addObject:[gameplayState pollenSystem]];
		[_systems addObject:[gameplayState sandSystem]];
		[_systems addObject:[gameplayState spawnSystem]];
		[_systems addObject:[gameplayState shakeSystem]];
		[_systems addObject:[gameplayState healthSystem]];
		[_systems addObject:[gameplayState respawnSystem]];
		[_systems addObject:[gameplayState disposalSystem]];
		[_systems addObject:[gameplayState gameRulesSystem]];
    }
    return self;
}

-(void) enter
{
	[super enter];

	[[_gameplayState inAppLayer] ensureInView:FALSE];
}

-(GameMode *) nextMode
{
	if ([[_gameplayState beeQueueRenderingSystem] isBusy])
	{
		return nil;
	}
	
    if ([[_gameplayState gameRulesSystem] isLevelCompleted])
    {
        return _levelCompletedMode;
    }
    else if ([[_gameplayState gameRulesSystem] isLevelFailed])
    {
        return _levelFailedMode;
    }
    
    GroupManager *groupManager = (GroupManager *)[[_gameplayState world] getManager:[GroupManager class]];

    NSArray *projectileEntities = [groupManager getEntitiesInGroup:@"PROJECTILES"];
	if ([projectileEntities count] > 0)
	{
		return nil;
	}

    NSArray *beeEntities = [groupManager getEntitiesInGroup:@"BEES"];
    BOOL isBeeFlying = FALSE;
    for (Entity *beeEntity in beeEntities)
    {
        if (![EntityUtil isEntityDisposed:beeEntity])
        {
            isBeeFlying = TRUE;
			break;
        }
    }
    if (!isBeeFlying)
    {
        return _aimingMode;
    }
    
    return nil;
}

@end
