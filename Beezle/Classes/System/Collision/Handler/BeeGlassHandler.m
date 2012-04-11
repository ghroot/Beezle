//
//  BeeGlassHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeGlassHandler.h"
#import "Collision.h"
#import "SoundManager.h"

@implementation BeeGlassHandler

-(void) handleCollision:(Collision *)collision
{
	[[SoundManager sharedManager] playSound:@"BeeHitGlass"];
}

@end
