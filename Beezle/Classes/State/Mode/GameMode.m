//
//  GameMode.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"

@interface GameMode()

-(void) processSystems;

@end

@implementation GameMode

// Designated initialiser
-(id) initWithGameplayState:(GameplayState *)gameplayState
{
    if (self = [super init])
    {
		_gameplayState = gameplayState;
		_systems = [NSMutableArray new];
    }
    return self;
}

-(id) init
{
    return [self initWithGameplayState:nil];
}

-(void) dealloc
{
    [_systems release];
    
    [super dealloc];
}

-(void) enter
{
    for (EntitySystem *system in _systems)
    {
        [system activate];
    }
}

-(void) update:(float)delta
{
	[self processSystems];
}

-(void) processSystems
{
    for (EntitySystem *system in _systems)
    {
        [system process];
    }
}

-(void) leave
{
    for (EntitySystem *system in _systems)
    {
        [system deactivate];
    }
}

-(GameMode *) nextMode
{
    return nil;
}

@end
