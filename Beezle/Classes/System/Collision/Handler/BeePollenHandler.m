//
//  BeePollenHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeePollenHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "LevelSession.h"

@implementation BeePollenHandler

+(id) handlerWithLevelSession:(LevelSession *)levelSession
{
    return [[[self alloc] initWithLevelSession:levelSession] autorelease];
}

-(id) initWithLevelSession:(LevelSession *)levelSession
{
    if (self = [super init])
    {
        _levelSession = levelSession;
    }
    return self;
}

-(void) handleCollision:(Collision *)collision
{
    Entity *pollenEntity = [collision secondEntity];
    
    if (![EntityUtil isEntityDisposed:pollenEntity])
    {
        [EntityUtil setEntityDisposed:pollenEntity];
		[_levelSession consumedEntity:pollenEntity];
        [EntityUtil animateAndDeleteEntity:pollenEntity];
    }
}

@end
