//
//  StateBasedGame.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "Game.h"

@class GameState;

@interface StateBasedGame : Game
{
	NSMutableDictionary *_statesById;
	GameState *_currentState;
}

-(void) addState:(GameState *)state;
-(void) enterState:(int)id;
-(GameState *) getCurrentState;
-(int) getCurrentStateId;
-(GameState *) getState:(int)stateId;

@end
