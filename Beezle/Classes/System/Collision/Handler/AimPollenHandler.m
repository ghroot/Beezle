//
//  AimPollenHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimPollenHandler.h"
#import "Collision.h"
#import "CollisionType.h"
#import "EntityUtil.h"

@implementation AimPollenHandler

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world andLevelSession:levelSession])
    {
        _firstCollisionType = [CollisionType AIM_POLLEN];
		[_secondCollisionTypes addObject:[CollisionType EDGE]];
    }
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *aimPollenEntity = [collision firstEntity];
    
	[EntityUtil setEntityDisposed:aimPollenEntity];
    
    return FALSE;
}

@end
