//
//  GameMode.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@implementation GameMode

+(GameMode *) mode
{
    return [[[self alloc] init] autorelease];
}

+(GameMode *) modeWithSystems:(NSArray *)systems
{
    return [[[self alloc] initWithSystems:systems] autorelease];
}

// Designated initialiser
-(id) initWithSystems:(NSArray *)systems
{
    if (self = [super init])
    {
        _systems = [systems retain];
    }
    return self;
}

-(id) init
{
    return [self initWithSystems:[NSArray array]];
}

-(void) dealloc
{
    [_systems release];
    
    [super dealloc];
}

-(void) processSystems
{
    for (EntitySystem *system in _systems)
    {
        [system process];
    }
}

-(void) enter
{
    // NOTE: This is mainly here for InputSystem, could possibly be solved in a better way
    for (EntitySystem *system in _systems)
    {
        [system activate];
    }
}

-(void) leave
{
    // NOTE: This is mainly here for InputSystem, could possibly be solved in a better way
    for (EntitySystem *system in _systems)
    {
        [system deactivate];
    }
}

@end
