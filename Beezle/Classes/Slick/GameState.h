//
//  GameState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class GameContainer;
@class StateBasedGame;

@interface GameState : NSObject
{
	int _stateId;
}

@property (nonatomic, readonly) int stateId;

-(id) initWithId:(int)stateId;
-(void) initialiseWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game;
-(void) enterWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game;
-(void) updateWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game delta:(int)delta;
-(void) renderWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game;
-(void) leaveWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game;

@end
