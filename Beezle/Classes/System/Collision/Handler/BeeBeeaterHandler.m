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

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *beeaterEntity = [collision secondEntity];
    
    BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
    if ([beeComponent killsBeeaters])
    {
        if (![EntityUtil isEntityDisposed:beeaterEntity])
        {
            [EntityUtil setEntityDisposed:beeaterEntity];
            
            [beeComponent decreaseBeeaterHitsLeft];
            if ([beeComponent isOutOfBeeaterKills])
            {
                [EntityUtil setEntityDisposed:beeEntity];
                [EntityUtil animateAndDeleteEntity:beeEntity disablePhysics:TRUE];
            }
        }
        
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

@end
