//
//  BeeBackgroundHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeBackgroundHandler.h"
#import "Collision.h"
#import "SoundManager.h"

#define VELOCITY_TIMES_MASS_FOR_SOUND 80.0f

@implementation BeeBackgroundHandler

-(BOOL) handleCollision:(Collision *)collision
{
    if ([collision firstEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
	{
		[[SoundManager sharedManager] playSound:@"BeeHitWall"];
	}
    
    return TRUE;
}

@end
