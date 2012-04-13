//
//  BeeNutHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeNutHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "LevelSession.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"

@implementation BeeNutHandler

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

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *nutEntity = [collision secondEntity];
    
    if (![EntityUtil isEntityDisposed:nutEntity])
	{
        [EntityUtil setEntityDisposed:nutEntity];
		[_levelSession consumedEntity:nutEntity];
		[[PhysicsComponent getFrom:nutEntity] disable];
		[nutEntity refresh];
        [[RenderComponent getFrom:nutEntity] playDefaultDestroyAnimation];
        [EntityUtil playDefaultDestroySound:nutEntity];
		
        [EntityUtil setEntityDisposed:beeEntity];
        [EntityUtil animateAndDeleteEntity:beeEntity];
	}
    
    return TRUE;
}

@end
