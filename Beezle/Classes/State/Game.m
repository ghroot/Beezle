//
//  Game.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "GameState.h"
#import "LoadingState.h"

#define TRANSITION_DURATION 0.2f

@implementation Game

-(id) init
{
    if (self = [super init])
    {
        _gameStateStack = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_gameStateStack release];
    
    [super dealloc];
}

-(void) startWithState:(GameState *)gameState
{
	if ([gameState needsLoadingState])
	{
		[self startWithState:[LoadingState stateWithGameState:gameState]];
	}
	else
	{
		[_gameStateStack addObject:gameState];
		[gameState setGame:self];
		[gameState initialise];
		[gameState enter];
		[[CCDirector sharedDirector] pushScene:gameState];
	}
}

-(void) replaceState:(GameState *)gameState
{
	if ([gameState needsLoadingState] &&
		![gameState isInitalised])
	{
		[self replaceState:[LoadingState stateWithGameState:gameState]];
	}
	else
	{
		[[self currentState] leave];
		[_gameStateStack removeLastObject];
		
		[_gameStateStack addObject:gameState];
		[gameState setGame:self];
		if (![gameState isInitalised])
		{
			[gameState initialise];
		}
		[gameState enter];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:gameState]];
    }
}

-(void) pushState:(GameState *)gameState
{
	if ([gameState needsLoadingState] &&
		![gameState isInitalised])
	{
		[self replaceState:[LoadingState stateWithGameState:gameState]];
	}
	else
	{
		[[self currentState] leave];
		
		[_gameStateStack addObject:gameState];
		[gameState setGame:self];
		if (![gameState isInitalised])
		{
			[gameState initialise];
		}
		[gameState enter];
		[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:gameState]];
	}
}

-(void) popState
{
    [[self currentState] leave];
    [_gameStateStack removeLastObject];
    [[self currentState] enter];
	[[CCDirector sharedDirector] popScene];
}

-(void) clearAndReplaceState:(GameState *)gameState
{
	while ([_gameStateStack count] > 1)
	{
		[_gameStateStack removeObjectAtIndex:0];
	}
	[self replaceState:gameState];
}

-(GameState *) currentState
{
	if ([_gameStateStack count] > 0)
	{
		return [_gameStateStack lastObject];
	}
	else
	{
		return nil;
	}
}

-(GameState *) previousState
{
	if ([_gameStateStack count] > 1)
	{
		return [_gameStateStack objectAtIndex:[_gameStateStack count] - 2];
	}
	else
	{
		return nil;
	}
}

@end
