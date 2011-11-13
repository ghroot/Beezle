//
//  SystemManager.m
//  Beezle
//
//  Created by Me on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SystemManager.h"

#import "World.h"

@implementation SystemManager

@synthesize systems = _systems;

-(id) initWithWorld:(World *)world
{
    if (self = [super init])
    {
        _world = world;
        _systems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(EntitySystem *) setSystem:(EntitySystem *)system
{
    [system setWorld:_world];
    [_systems addObject:system];
    return system;
}

-(EntitySystem *) getSystem:(Class)systemClass
{
    EntitySystem *systemToReturn = NULL;
    for (EntitySystem *system in _systems)
    {
        if ([system isKindOfClass:systemClass])
        {
            systemToReturn = system;
            break;
        }
    }
    return systemToReturn;
}

-(void) initialiseAll
{
    for (EntitySystem *system in _systems)
    {
        [system initialise];
    }
}

-(void) processAll
{
    for (EntitySystem *system in _systems)
    {
        [system process];
    }
}

-(void) dealloc
{
    [_systems release];
    
    [super dealloc];
}

@end
