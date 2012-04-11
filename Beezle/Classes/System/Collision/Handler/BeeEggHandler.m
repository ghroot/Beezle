//
//  BeeEggHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeEggHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "LevelSession.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"

@implementation BeeEggHandler

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
    Entity *beeEntity = [collision firstEntity];
    Entity *eggEntity = [collision secondEntity];
    
    if (![EntityUtil isEntityDisposed:eggEntity])
	{
        [EntityUtil setEntityDisposed:eggEntity];
		[_levelSession consumedEntity:eggEntity];
		[[PhysicsComponent getFrom:eggEntity] disable];
		[eggEntity refresh];
        [[RenderComponent getFrom:eggEntity] playDefaultDestroyAnimation];
        [EntityUtil playDefaultDestroySound:eggEntity];
		
        [EntityUtil setEntityDisposed:beeEntity];
        [EntityUtil animateAndDeleteEntity:beeEntity];
	}
}

@end
