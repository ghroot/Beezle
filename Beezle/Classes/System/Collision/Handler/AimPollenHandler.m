//
//  AimPollenHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimPollenHandler.h"
#import "Collision.h"
#import "EntityUtil.h"

@implementation AimPollenHandler

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *aimPollenEntity = [collision firstEntity];
    
	[EntityUtil setEntityDisposed:aimPollenEntity];
    
    return FALSE;
}

@end
