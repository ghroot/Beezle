//
//  EntityManager.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityManager.h"

@implementation EntityManager

-(id) init
{
    if (self = [super init])
    {
        _nextEntityId = 1;
        _entities = [[NSMutableArray alloc] init];
        _componentsByClass = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(Entity *) createEntity
{
    Entity *entity = [[[Entity alloc] initWithEntityManage:self] autorelease];
    entity.entityId = _nextEntityId++;
    [_entities addObject:entity];
    return entity;
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

-(AbstractComponent *) getComponent:(Class)componentClass fromEntity:(Entity *)entity
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

@end
