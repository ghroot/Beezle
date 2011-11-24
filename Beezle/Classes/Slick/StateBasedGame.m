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
		
		// Empty state on creation to avoid nil issues
		_currentState = [[[GameState alloc] initWithId:-1] autorelease];
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
	
	// Replace placeholder state
	if ([_currentState stateId] == -1)
	{
		_currentState = state;
	}
}

-(void) enterState:(int)stateId
{
	[_currentState leaveWithContainer:_container andGame:self];
	_currentState = [self getState:stateId];
	[_currentState enterWithContainer:_container andGame:self];
}

-(void) initialiseStatesListWithContainer:(GameContainer *)container
{
}

-(GameState *) getCurrentState
{
	return _currentState;
}

-(int) getCurrentStateId
{
	return [_currentState stateId];
}

-(GameState *) getState:(int)stateId
{
	return [_statesById objectForKey:[NSNumber numberWithInt:stateId]];
}

-(void) initialiseWithContainer:(GameContainer *)container
{
    _container = container;
	
	// Create states
	[self initialiseStatesListWithContainer:container];
    
	// Initialise states
    for (GameState *state in [_statesById allValues])
    {
        [state initialiseWithContainer:_container andGame:self];
    }
	
	[_currentState enterWithContainer:_container andGame:self];
}

-(void) updateWithContainer:(GameContainer *)container andDelta:(int)delta
{
	[_currentState updateWithContainer:_container andGame:self delta:delta];
}

-(void) renderWithContainer:(GameContainer *)container
{
	[_currentState renderWithContainer:_container andGame:self];
}

-(void) touchBegan:(Touch *)touch
{
	[_currentState touchBeganWithContainer:_container andGame:self touch:touch];
}

-(void) touchMoved:(Touch *)touch
{
	[_currentState touchMovedWithContainer:_container andGame:self touch:touch];
}

-(void) touchEnded:(Touch *)touch
{
	[_currentState touchEndedWithContainer:_container andGame:self touch:touch];
}

@end
