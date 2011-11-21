//
//  Actor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "Component.h"
#import "EntityManager.h"
#import "TagManager.h"
#import "World.h"

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

-(void) removeComponent:(Component *)component
{
    [_entityManager removeComponent:component fromEntity:self];
}

-(Component *) getComponent:(Class)componentClass;
{
    return [_entityManager getComponentWithClass:componentClass fromEntity:self];
}

-(BOOL) hasComponent:(Class)componentClass
{
    return [self getComponent:componentClass] != nil;
}

-(void) refresh
{
    [_world refreshEntity:self];
}

-(void) deleteEntity
{
    [_world deleteEntity:self];
}

-(void) setTag:(NSString *)tag
{
    [[_world tagManager] registerEntity:self withTag:tag];
}

@end
