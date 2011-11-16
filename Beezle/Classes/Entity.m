//
//  Actor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

#import "World.h"
#import "EntityManager.h"

@implementation Entity

@synthesize entityId = _entityId;
@synthesize world = _world;
@synthesize deleted = _deleted;

-(id) initWithWorld:(World *)world andId:(int)entityId
{
    if (self = [super init])
    {
        _world = world;
        _entityManager = [_world entityManager];
        _entityId = entityId;
    }
    return self;
}

-(void) addComponent:(Component *)component
{
    [_entityManager addComponent:component toEntity:self];
}

-(Component *) getComponent:(Class)componentClass;
{
    return [_entityManager getComponentWithClass:componentClass fromEntity:self];
}

-(void) refresh
{
    [_entityManager refreshEntity:self];
}

-(void) deleteEntity
{
    [_world deleteEntity:self];
}

@end
