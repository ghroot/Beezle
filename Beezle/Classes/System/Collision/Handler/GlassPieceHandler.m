//
//  GlassPieceHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlassPieceHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "Utils.h"

@implementation GlassPieceHandler

+(id) handlerWithWorld:(World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

-(id) initWithWorld:(World *)world
{
    if (self = [super init])
    {
        _world = world;
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
