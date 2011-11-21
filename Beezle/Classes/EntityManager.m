//
//  EntityManager.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "Entity.h"
#import "EntityManager.h"
#import "EntitySystem.h"
#import "SystemManager.h"
#import "World.h"

@implementation EntityManager

-(id) initWithWorld:(World *)world
{
    if (self = [super init])
    {
        _world = world;
        _nextEntityId = 1;
        _entities = [[NSMutableArray alloc] init];
        _componentsByClass = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(Entity *) createEntity
{
    Entity *entity = [[[Entity alloc] initWithWorld:_world andId:++_nextEntityId] autorelease];
    [_entities addObject:entity];
    return entity;
}

-(void) removeEntity:(Entity *)entity
{
    [_entities removeObject:entity];
    [entity setDeleted:TRUE];
    [self refreshEntity:entity];
    [self removeAllComponentsFromEntity:entity];
}

-(void) removeAllComponentsFromEntity:(Entity *)entity
{
    for (NSMutableDictionary *componentsByEntity in [_componentsByClass allValues])
    {
        [componentsByEntity removeObjectForKey:[NSNumber numberWithInt:[entity entityId]]];
    }
}

-(void) addComponent:(Component *)component toEntity:(Entity *)entity
{
    NSMutableDictionary *_componentsByEntity;
    if ([_componentsByClass objectForKey:[component class]] == nil)
    {
        _componentsByEntity = [[NSMutableDictionary alloc] init];
        [_componentsByClass setObject:_componentsByEntity forKey:[component class]];
    }
    else
    {
        _componentsByEntity = [_componentsByClass objectForKey:[component class]];
    }
    [_componentsByEntity setObject:component forKey:[NSNumber numberWithInt:[entity entityId]]];
}

-(void) refreshEntity:(Entity *)entity
{
    NSArray *systems = [[_world systemManager] systems] ;
    for (EntitySystem *system in systems)
    {
        [system entityChanged:entity];
    }
}

-(void) removeComponent:(Component *)component fromEntity:(Entity *)entity
{
    [self removeComponentWithClass:[component class] fromEntity:entity];
}

-(void) removeComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity
{
    NSMutableDictionary *componentsByEntity = [_componentsByClass objectForKey:componentClass];
    [componentsByEntity removeObjectForKey:[NSNumber numberWithInt:[entity entityId]]];
}

-(Component *) getComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity
{
    if ([_componentsByClass objectForKey:componentClass] != nil)
    {
        NSMutableDictionary *_componentsByEntity = [_componentsByClass objectForKey:componentClass];
        return [_componentsByEntity objectForKey:[NSNumber numberWithInt:[entity entityId]]];
    }
    else
    {
        return nil;
    }
}

-(Entity *) getEntity:(int)entityId
{
    Entity *entityToReturn = nil;
    for (Entity *entity in _entities)
    {
        if ([entity entityId] == entityId)
        {
            entityToReturn = entity;
            break;
        }
    }
    return entityToReturn;
}

-(NSArray *) getComponents:(Entity *)entity
{
    NSMutableArray *entityComponents = [NSMutableArray array];
    for (NSMutableDictionary *componentsByEntity in [_componentsByClass allValues])
    {
        Component *component = [componentsByEntity objectForKey:entity];
        if (component != NULL)
        {
            [entityComponents addObject:component];
        }
    }
    return entityComponents;
}

@end
