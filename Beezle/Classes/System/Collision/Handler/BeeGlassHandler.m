//
//  BeeGlassHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeGlassHandler.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "Collision.h"
#import "NotificationTypes.h"
#import "SoundManager.h"

#define VELOCITY_TIMES_MASS_FOR_SOUND 80.0f

@implementation BeeGlassHandler

-(BOOL) handleCollision:(Collision *)collision
{
    if ([collision firstEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
    {
        [[SoundManager sharedManager] playSound:@"BeeHitGlass"];
    }
    
    return TRUE;
}

@end
