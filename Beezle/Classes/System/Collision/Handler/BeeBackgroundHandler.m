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

@implementation BeeBackgroundHandler

-(void) handleCollision:(Collision *)collision
{
    if ([collision impulseLength] >= 50)
	{
		[[SoundManager sharedManager] playSound:@"BeeHitWall"];
	}
}

@end
