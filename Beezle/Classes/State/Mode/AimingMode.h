//
//  AimingMode.h
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@class ShootingMode;

@interface AimingMode : GameMode
{
    ShootingMode *_shootingMode;
}

@property (nonatomic, assign) ShootingMode *shootingMode;

@end
