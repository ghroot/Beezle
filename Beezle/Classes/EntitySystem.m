//
//  EntitySystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"
#import "Component.h"
#import "Entity.h"

@implementation EntitySystem

@synthesize world = _world;

-(id) initWithUsedComponentClasses:(NSMutableArray *)usedComponentClasses
{
    if (self = [super init])
    {
        _usedComponentClasses = [usedComponentClasses retain];
        _entities = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) init
{
    return [self initWithUsedComponentClasses:[NSMutableArray array]];
}

-(void) begin
{
}

-(void) process
{
    if ([self checkProcessing])
    {
        [self begin];
        [self processEntities:_entities];
        [self end];
    }
}

-(void) end
{
}

-(void) processEntities:(NSArray *)entities
{
}

-(BOOL) checkProcessing
{
    return TRUE;
}

-(void) initialise
{
}

-(void) entityAdded:(Entity *)entity
{
}

-(void) entityRemoved:(Entity *)entity
{
}

-(void) entityChanged:(Entity *)entity
{
    BOOL hasAllUsedComponents = TRUE;
    for (Class usedComponentClass in _usedComponentClasses)
    {
        Component *component = [entity getComponent:usedComponentClass];
        if (component == nil || ![component enabled])
        {
            hasAllUsedComponents = FALSE;
            break;
        }
    }
    
    if ([_entities containsObject:entity] && (!hasAllUsedComponents || [entity deleted]))
    {
        [self removeEntity:entity];
    }
    else if (![_entities containsObject:entity] && hasAllUsedComponents)
    {
        [_entities addObject:entity];
        [self entityAdded:entity];
    }
}

-(void) removeEntity:(Entity *)entity
{
    [_entities removeObject:entity];
    [self entityRemoved:entity];
}

-(BOOL) hasEntity:(Entity *)entity
{
    return [_entities containsObject:entity];
}

-(void) dealloc
{
    [_usedComponentClasses release];
    [_entities release];
    
    [super dealloc];
}

@end
