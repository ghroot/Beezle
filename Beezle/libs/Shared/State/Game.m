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

-(void) replaceState:(GameState *)gameState transition:(BOOL)transition
{
	if ([gameState needsLoadingState] &&
		![gameState isInitalised])
	{
		[self replaceState:[LoadingState stateWithGameState:gameState] transition:transition];
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
		if (transition)
		{
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:gameState]];
		}
		else
		{
			[[CCDirector sharedDirector] replaceScene:gameState];
		}
    }
}

-(void) replaceState:(GameState *)gameState
{
	[self replaceState:gameState transition:TRUE];
}

-(void) pushState:(GameState *)gameState transition:(BOOL)transition
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
		if (transition)
		{
			[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:gameState]];
		}
		else
		{
			[[CCDirector sharedDirector] pushScene:gameState];
		}
	}
}

-(void) pushState:(GameState *)gameState
{
	[self pushState:gameState transition:TRUE];
}

-(void) popState
{
    [[self currentState] leave];
    [_gameStateStack removeLastObject];
    [[self currentState] enter];
	[[CCDirector sharedDirector] popScene];
}

-(void) clearAndReplaceState:(GameState *)gameState transition:(BOOL)transition
{
	while ([_gameStateStack count] > 1)
	{
		[self popState];
	}
	[self replaceState:gameState transition:transition];
}

-(void) clearAndReplaceState:(GameState *)gameState
{
	[self clearAndReplaceState:gameState transition:TRUE];
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
