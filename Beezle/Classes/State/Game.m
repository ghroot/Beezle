//
//  Game.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "GameState.h"

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
    [_gameStateStack addObject:gameState];
	[gameState setGame:self];
    [gameState enter];
	[[CCDirector sharedDirector] pushScene:gameState];
}

-(void) replaceState:(GameState *)gameState
{
    [self replaceState:gameState withTransition:nil];
}

-(void) replaceState:(GameState *)gameState withTransition:(Class)transitionClass
{
	GameState *previousGameState = [_gameStateStack lastObject];
    [_gameStateStack removeLastObject];
    [previousGameState leave];
    [_gameStateStack addObject:gameState];
    [gameState setGame:self];
    [gameState enter];
	if (transitionClass != nil)
	{
		[[CCDirector sharedDirector] setNeedClear:TRUE];
		[[CCDirector sharedDirector] replaceScene:[transitionClass transitionWithDuration:1.0f scene:gameState]];
	}
	else
	{
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0f scene:gameState]];
	}
}

-(void) pushState:(GameState *)gameState
{
    GameState *previousGameState = [_gameStateStack lastObject];
    [previousGameState leave];
    [_gameStateStack addObject:gameState];
	[gameState setGame:self];
    [gameState enter];
	[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.0f scene:gameState]];
}

-(void) popState
{
    GameState *previousGameState = [_gameStateStack lastObject];
    [_gameStateStack removeLastObject];
    [previousGameState leave];
    GameState *newGameState = [_gameStateStack lastObject];
    [newGameState enter];
	[[CCDirector sharedDirector] popScene];
}

-(void) popAndReplaceState:(GameState *)gameState
{
    GameState *previousGameState = [_gameStateStack lastObject];
    [_gameStateStack removeLastObject];
    [previousGameState leave];
    [[CCDirector sharedDirector] popScene];
    
    [_gameStateStack removeLastObject];
    
    [_gameStateStack addObject:gameState];
	[gameState setGame:self];
    [gameState enter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0f scene:gameState]];
}

-(GameState *) currentState
{
	return [_gameStateStack lastObject];
}

@end
