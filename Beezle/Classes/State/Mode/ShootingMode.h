//
//  ShootingMode.h
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@class AimingMode;
@class GameRulesSystem;
@class LevelCompleteMode;
@class LevelFailedMode;

@interface ShootingMode : GameMode
{
    AimingMode *_aimingMode;
    LevelCompleteMode *_levelCompletedMode;
    LevelFailedMode *_levelFailedMode;
    
    GameRulesSystem *_gameRulesSystem;
}

@property (nonatomic, assign) AimingMode *aimingMode;
@property (nonatomic, assign) LevelCompleteMode *levelCompletedMode;
@property (nonatomic, assign) LevelFailedMode *levelFailedMode;

@end
