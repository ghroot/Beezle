/**
* Based on Artemis Entity System Framework
* 
* Copyright 2011 GAMADU.COM. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY GAMADU.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL GAMADU.COM OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of GAMADU.COM.
*/

#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"
#import "EntitySystem.h"
#import "SystemManager.h"
#import "World.h"

@implementation EntityManager

@synthesize entities = _entities;

-(id) initWithWorld:(World *)world
{
    if (self = [super initWithWorld:world])
    {
        _nextEntityId = 1;
        _entities = [[NSMutableArray alloc] init];
        _componentsByClass = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_entities release];
    [_componentsByClass release];
    
    [super dealloc];
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
    NSMutableDictionary *componentsByEntity;
    if ([_componentsByClass objectForKey:[component class]] == nil)
    {
        componentsByEntity = [[[NSMutableDictionary alloc] init] autorelease];
        [_componentsByClass setObject:componentsByEntity forKey:[component class]];
    }
    else
    {
        componentsByEntity = [_componentsByClass objectForKey:[component class]];
    }
    [componentsByEntity setObject:component forKey:[NSNumber numberWithInt:[entity entityId]]];
}

-(void) refreshEntity:(Entity *)entity
{
    NSArray *systems = [[_world systemManager] systems];
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