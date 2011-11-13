//
//  World.m
//  Beezle
//
//  Created by Me on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"

@implementation World

@synthesize entityManager = _entityManager;
@synthesize systemManager = _systemManager;
@synthesize tagManager = _tagManager;
@synthesize delta = _delta;

-(id) init
{
    if (self = [super init])
    {
        _entityManager = [[EntityManager alloc] initWithWorld:self];
        _systemManager = [[SystemManager alloc] initWithWorld:self];
        _tagManager = [[TagManager alloc] init];
        
        _refreshed = [[NSMutableArray alloc] init];
        _deleted = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) deleteEntity:(Entity *)entity
{
    if (![_deleted containsObject:entity])
    {
        [_deleted addObject:entity];
    }
}

-(void) refreshEntity:(Entity *)entity
{
    [_refreshed addObject:entity];
}

-(Entity *) createEntity
{
    return [_entityManager createEntity];
}

-(Entity *) getEntity:(int) entityId
{
    return [_entityManager getEntity:entityId];
}

-(void) loopStart
{
    if ([_refreshed count] > 0)
    {
        for (Entity *entity in _refreshed)
        {
            [_entityManager refresh:entity];
        }
        [_refreshed removeAllObjects];
    }
    
    if  ([_deleted count] > 0)
    {
        for (Entity *entity in _deleted)
        {
            [_entityManager remove:entity];
        }
        [_deleted removeAllObjects];
    }
}

-(void) dealloc
{
    [_entityManager release];
    [_systemManager release];
    
    [_refreshed release];
    [_deleted release];
    
    [super dealloc];
}

@end
