//
//  BeeEdgeHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeEdgeHandler.h"
#import "Collision.h"
#import "EntityUtil.h"

@implementation BeeEdgeHandler

-(void) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    
    [EntityUtil setEntityDisposed:beeEntity];
	[beeEntity deleteEntity];
}

@end
