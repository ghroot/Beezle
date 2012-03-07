//
//  GameMode.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@implementation GameMode

@synthesize name = _name;

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
    [_transitionBlock release];
    [_enterBlock release];
    [_systems release];
    
    [super dealloc];
}

-(void) setTransitionBlock:(BOOL(^)(void))block
{
	_transitionBlock = [block copy];
}

-(BOOL) shouldTransition
{
    return _transitionBlock();
}

-(void) setEnterBlock:(void(^)(void))block
{
    _enterBlock = [block copy];
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
    for (EntitySystem *system in _systems)
    {
        [system activate];
    }
    
    if (_enterBlock != nil)
    {
        _enterBlock();
    }
}

-(void) leave
{
    for (EntitySystem *system in _systems)
    {
        [system deactivate];
    }
}

@end
