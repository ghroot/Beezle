//
//  ShootingMode.h
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@class AimingMode;
@class LevelCompletedMode;
@class LevelFailedMode;

@interface ShootingMode : GameMode
{
    AimingMode *_aimingMode;
    LevelCompletedMode *_levelCompletedMode;
    LevelFailedMode *_levelFailedMode;
}

@property (nonatomic, assign) AimingMode *aimingMode;
@property (nonatomic, assign) LevelCompletedMode *levelCompletedMode;
@property (nonatomic, assign) LevelFailedMode *levelFailedMode;

@end
