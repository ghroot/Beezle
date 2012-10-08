//
//  AimingMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimingMode.h"
#import "EntityUtil.h"
#import "GameplayState.h"
#import "ShootingMode.h"
#import "PlayerInformation.h"

@implementation AimingMode

@synthesize shootingMode = _shootingMode;

-(id) initWithGameplayState:(GameplayState *)gameplayState
{
	if (self = [super initWithGameplayState:gameplayState])
	{
		[_systems addObject:[gameplayState movementSystem]];
		[_systems addObject:[gameplayState physicsSystem]];
		[_systems addObject:[gameplayState collisionSystem]];
		[_systems addObject:[gameplayState waterWaveSystem]];
		[_systems addObject:[gameplayState teleportSystem]];
		[_systems addObject:[gameplayState renderSystem]];
		[_systems addObject:[gameplayState hudRenderingSystem]];
		[_systems addObject:[gameplayState inputSystem]];
		if ([[PlayerInformation sharedInformation] usingAdvancedControlScheme])
		{
			[_systems addObject:[gameplayState advancedSlingerControlSystem]];
		}
		else
		{
			[_systems addObject:[gameplayState simpleSlingerControlSystem]];
		}
		[_systems addObject:[gameplayState aimPollenShooterSystem]];
		[_systems addObject:[gameplayState freezeSystem]];
		[_systems addObject:[gameplayState beeaterSystem]];
		[_systems addObject:[gameplayState capturedSystem]];
		[_systems addObject:[gameplayState beeQueueRenderingSystem]];
		[_systems addObject:[gameplayState shardSystem]];
		[_systems addObject:[gameplayState spawnSystem]];
		[_systems addObject:[gameplayState shakeSystem]];
		[_systems addObject:[gameplayState disposalSystem]];
		[_systems addObject:[gameplayState gameRulesSystem]];
	}
	return self;
}

-(GameMode *) nextMode
{
    GroupManager *groupManager = (GroupManager *)[[_gameplayState world] getManager:[GroupManager class]];
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
