//
//  GlassPieceHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlassPieceHandler.h"
#import "Collision.h"
#import "CollisionType.h"
#import "EntityUtil.h"

@implementation GlassPieceHandler

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world andLevelSession:levelSession])
    {
        _firstCollisionType = [CollisionType GLASS_PIECE];
        [_secondCollisionTypes addObject:[CollisionType BACKGROUND]];
		[_secondCollisionTypes addObject:[CollisionType EDGE]];
    }
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *glassPieceEntity = [collision firstEntity];
	
	[EntityUtil setEntityDisposed:glassPieceEntity];
	[EntityUtil playDefaultDestroySound:glassPieceEntity];
    
    return TRUE;
}

@end
