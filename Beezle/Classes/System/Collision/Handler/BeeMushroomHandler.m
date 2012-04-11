//
//  BeeMushroomHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeMushroomHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "SoundManager.h"

@implementation BeeMushroomHandler

-(void) handleCollision:(Collision *)collision
{
    Entity *mushroomEntity = [collision secondEntity];
    
    if ([EntityUtil isEntityDisposable:mushroomEntity])
	{
        if (![EntityUtil isEntityDisposed:mushroomEntity])
		{
            [EntityUtil setEntityDisposed:mushroomEntity];
            [EntityUtil animateAndDeleteEntity:mushroomEntity disablePhysics:FALSE];
            [EntityUtil playDefaultDestroySound:mushroomEntity];
		}
	}
	else
	{
		[[RenderComponent getFrom:mushroomEntity] playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
		[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
	}
}

@end
