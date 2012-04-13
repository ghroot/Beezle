//
//  AimPollenEdgeHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimPollenEdgeHandler.h"
#import "Collision.h"
#import "EntityUtil.h"

@implementation AimPollenEdgeHandler

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *aimPollenEntity = [collision firstEntity];
    
    if (![EntityUtil isEntityDisposed:aimPollenEntity])
    {
        [EntityUtil setEntityDisposed:aimPollenEntity];
        [aimPollenEntity deleteEntity];
    }
    
    return TRUE;
}

@end
