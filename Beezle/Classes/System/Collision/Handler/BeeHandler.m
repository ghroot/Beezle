//
//  BeeHandler.m
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeHandler.h"
#import "Collision.h"
#import "CrumbleComponent.h"
#import "DozerComponent.h"
#import "EntityUtil.h"

@implementation BeeHandler

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *otherEntity = [collision secondEntity];
	
	if ([EntityUtil isEntityDisposed:otherEntity])
	{
		return FALSE;
	}
	else if ([beeEntity hasComponent:[DozerComponent class]] &&
			[otherEntity hasComponent:[CrumbleComponent class]])
	{
		[EntityUtil setEntityDisposed:otherEntity];
		
		return FALSE;
	}
    else
    {
        return TRUE;
    }
}

@end
