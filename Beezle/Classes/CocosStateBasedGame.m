//
//  CocosStateBasedGame.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosStateBasedGame.h"
#import "CocosGameContainer.h"
#import "CocosGameState.h"
#import "ForwardLayer.h"

@implementation CocosStateBasedGame

-(id) init
{
	if (self = [super init])
	{
		_stateStack = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_stateStack release];
	
	[super dealloc];
}

/**
* Enters the state with the specified id, replacing the current state
* (overrides parent class function)
*/
-(void) enterState:(int)stateId
{
	[_currentState leave];
	_currentState = [self getState:stateId];

	CocosGameState *cocosGameState = (CocosGameState *)_currentState;
    [[CCDirector sharedDirector] replaceScene:[cocosGameState scene]];
    [[cocosGameState layer] unscheduleUpdate];
    [[cocosGameState layer] scheduleUpdate];
	
	[_currentState enter];
}

/**
* Enters the state with the specified id, and pushes the current state onto a stack
*/
-(void) enterStateKeepCurrent:(int)stateId
{
	[_stateStack addObject:_currentState];
	[_currentState leave];
	_currentState = [self getState:stateId];

	CocosGameState *cocosGameState = (CocosGameState *)_currentState;
    [[CCDirector sharedDirector] pushScene:[cocosGameState scene]];
    [[cocosGameState layer] unscheduleUpdate];
    [[cocosGameState layer] scheduleUpdate];
	
	[_currentState enter];
}

/**
* Enters the state with the specified id, but first discards the first state on the stack
* A common use case for this is: Main Menu -> Game -> Ingame Menu -> Main Menu, here the Game state
* should be discarded when going from Ingame Menu to Main Menu
*/
-(void) enterStateDiscardPrevious:(int)stateId
{
	[_stateStack removeLastObject];
	[_currentState leave];
	_currentState = [self getState:stateId];

	CocosGameState *cocosGameState = (CocosGameState *)_currentState;
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] replaceScene:[cocosGameState scene]];
    [[cocosGameState layer] unscheduleUpdate];
    [[cocosGameState layer] scheduleUpdate];
	
	[_currentState enter];
}

/**
* Enters the state on the top of the stack
*/
-(void) enterPreviousState
{
	[_currentState leave];
	_currentState = [_stateStack lastObject];
	[_stateStack removeLastObject];
	
    CocosGameState *cocosGameState = (CocosGameState *)_currentState;
	[[CCDirector sharedDirector] popScene];
    [[cocosGameState layer] unscheduleUpdate];
    [[cocosGameState layer] scheduleUpdate];
	
	[_currentState enter];
}

@end
