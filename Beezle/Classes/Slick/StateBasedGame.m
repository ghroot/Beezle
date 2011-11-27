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
         GameState *emptyState = [[[GameState alloc] initWithId:-1] autorelease];
        [self addState:emptyState];
		_currentState = emptyState;
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
    [state setGame:self];
}

-(void) enterState:(int)stateId
{
	[_currentState leave];
	_currentState = [self getState:stateId];
	[_currentState enter];
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

-(void) initialise
{
    // Create states
	[self createStates];
    
	// Initialise states
    for (GameState *state in [_statesById allValues])
    {
        [state initialise];
    }
	
    // Enter current state (which is the empty state)
	[_currentState enter];
}

-(void) createStates
{
}

-(void) update:(int)delta
{
	[_currentState update:delta];
}

-(void) render
{
	[_currentState render];
}

-(void) touchBegan:(Touch *)touch
{
	[_currentState touchBegan:touch];
}

-(void) touchMoved:(Touch *)touch
{
	[_currentState touchMoved:touch];
}

-(void) touchEnded:(Touch *)touch
{
	[_currentState touchEnded:touch];
}

@end
