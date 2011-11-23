//
//  StateBasedGame.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StateBasedGame.h"

@implementation StateBasedGame

-(id) init
{
    if (self = [super init])
    {
		_statesById = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_statesById release];
	
	[super dealloc];
}

-(void) addState:(GameState *)state
{
	[_statesById setObject:state forKey:[NSNumber numberWithInt:[state stateId]]];
}

-(void) enterState:(int)stateId
{
	if (_currentState != nil)
	{
		// Leave current state before entering a new state
		[_currentState leaveWithContainer:_container andStateBasedGame:self];
	}
	
	_currentState = [self getState:stateId];
	
	[_currentState enterWithContainer:_container andStateBasedGame:self];
}

-(GameState *) getCurrentState
{
	return _currentState;
}

-(int) getCurrentStateId
{
	if (_currentState != nil)
	{
		return [_currentState stateId];
	}
	else
	{
		// Return -1 if there is no current state
		return -1;
	}
}

-(GameState *) getState:(int)stateId
{
	return [_statesById objectWithKey:[NSNumber numberWithInt:stateId]];
}

-(void) update:(int)delta
{
	if (_currentState != nil)
	{
		[_currentState updateWithContainer:_container andStateBasedGame:self delta:delta];
	}
}

-(void) render
{
	if (_currentState != nil)
	{
		[_currentState renderWithContainer:_container andStateBasedGame:self];
	}
}

@end
