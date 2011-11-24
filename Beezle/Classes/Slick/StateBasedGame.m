//
//  StateBasedGame.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StateBasedGame.h"
#import "GameState.h"
#import "Touch.h"

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
		[_currentState leaveWithContainer:_container andGame:self];
	}
	
	_currentState = [self getState:stateId];
	
	[_currentState enterWithContainer:_container andGame:self];
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
	return [_statesById objectForKey:[NSNumber numberWithInt:stateId]];
}

-(void) initialiseWithContainer:(GameContainer *)container
{
    _container = container;
    
    for (GameState *state in [_statesById allValues])
    {
        [state initialiseWithContainer:_container andGame:self];
    }
}

-(void) updateWithContainer:(GameContainer *)container andDelta:(int)delta
{
	if (_currentState != nil)
	{
		[_currentState updateWithContainer:_container andGame:self delta:delta];
	}
}

-(void) renderWithContainer:(GameContainer *)container
{
	if (_currentState != nil)
	{
		[_currentState renderWithContainer:_container andGame:self];
	}
}

-(void) touchBegan:(Touch *)touch
{
    if (_currentState != nil)
	{
		[_currentState touchBeganWithContainer:_container andGame:self touch:touch];
	}
}

-(void) touchMoved:(Touch *)touch
{
    if (_currentState != nil)
	{
		[_currentState touchMovedWithContainer:_container andGame:self touch:touch];
	}
}

-(void) touchEnded:(Touch *)touch
{
    if (_currentState != nil)
	{
		[_currentState touchEndedWithContainer:_container andGame:self touch:touch];
	}
}

@end
