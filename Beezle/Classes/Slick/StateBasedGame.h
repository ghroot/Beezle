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
    GameContainer *_container;
	NSMutableDictionary *_statesById;
	GameState *_currentState;
}

-(void) addState:(GameState *)state;
-(void) enterState:(int)id;
-(void) initialiseStatesListWithContainer:(GameContainer *)container;
-(GameState *) getCurrentState;
-(int) getCurrentStateId;
-(GameState *) getState:(int)stateId;

@end
