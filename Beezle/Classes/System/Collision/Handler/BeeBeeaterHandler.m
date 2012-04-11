//
//  BeeBeeaterHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeBeeaterHandler.h"
#import "BeeComponent.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"

@implementation BeeBeeaterHandler

-(void) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *beeaterEntity = [collision secondEntity];
    
    if (![EntityUtil isEntityDisposed:beeaterEntity])
    {
        [EntityUtil setEntityDisposed:beeaterEntity];
		
		NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:beeaterEntity forKey:@"beeaterEntity"];
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEEATER_HIT object:self userInfo:notificationUserInfo];
        
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		[beeComponent decreaseBeeaterHitsLeft];
		if ([beeComponent isOutOfBeeaterKills])
		{
            [EntityUtil setEntityDisposed:beeEntity];
            [EntityUtil animateAndDeleteEntity:beeEntity disablePhysics:TRUE];
		}
    }
}

@end
