/**
* Based on parts of Slick(tm) game engine
* 
* Copyright (c) 2007, Slick 2D
* 
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* * Neither the name of the Slick 2D nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
* A PARTICULAR PURPOSE ARE * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR * * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
* TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE * * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
