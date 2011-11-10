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

-(void) addComponent:(AbstractComponent *)component
{
    [_entityManager addComponent:component toEntity:self];
}

-(AbstractComponent *) getComponent:(Class)componentClass;
{
    return [_entityManager getComponentWithClass:componentClass fromEntity:self];
}

-(void) refresh
{
    [_entityManager refresh:self];
}

@end
