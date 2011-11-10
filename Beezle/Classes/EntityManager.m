//
//  EntityManager.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityManager.h"

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

-(void) remove:(Entity *)entity
{
    [_entities removeObject:entity];   
    [self refresh:entity];
    [self removeComponentsOfEntity:entity];
}

-(void) removeComponentsOfEntity:(Entity *)entity
{
    for (NSMutableDictionary *componentsByEntity in [_componentsByClass allValues])
    {
        [componentsByEntity setObject:NULL forKey:[NSNumber numberWithInt:[entity entityId]]];
    }
}

-(void) addComponent:(AbstractComponent *)component toEntity:(Entity *)entity
{
    NSMutableDictionary *_componentsByEntity;
    if ([_componentsByClass objectForKey:[component class]] == NULL)
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

-(void) refresh:(Entity *)entity
{
    NSArray *systems = [[_world systemManager] systems] ;
    for (AbstractEntitySystem *system in systems)
    {
        [system entityChanged:entity];
    }
}

-(void) removeComponent:(AbstractComponent *)component fromEntity:(Entity *)entity
{
    [self removeComponentWithClass:[component class] fromEntity:entity];
}

-(void) removeComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity
{
    NSMutableDictionary *componentsByEntity = [_componentsByClass objectForKey:componentClass];
    [componentsByEntity setObject:NULL forKey:entity];
}

-(AbstractComponent *) getComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity
{
    if ([_componentsByClass objectForKey:componentClass] != NULL)
    {
        NSMutableDictionary *_componentsByEntity = [_componentsByClass objectForKey:componentClass];
        return [_componentsByEntity objectForKey:[NSNumber numberWithInt:[entity entityId]]];
    }
    else
    {
        return NULL;
    }
}

-(Entity *) getEntity:(int)entityId
{
    Entity *entityToReturn = NULL;
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
        AbstractComponent *component = [componentsByEntity objectForKey:entity];
        if (component != NULL)
        {
            [entityComponents addObject:component];
        }
    }
    return entityComponents;
}

@end
