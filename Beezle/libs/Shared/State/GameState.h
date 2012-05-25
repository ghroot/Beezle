//
//  GameState.h
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class Game;

@interface GameState : CCScene <CCTargetedTouchDelegate>
{
	Game *_game;
	BOOL _isInitialised;
	BOOL _needsLoadingState;
}

@property (nonatomic, assign) Game *game;
@property (nonatomic, readonly) BOOL isInitalised;
@property (nonatomic, readonly) BOOL needsLoadingState;

+(id) state;

-(BOOL) needsLoadingState;
-(void) initialise;
-(void) enter;
-(void) leave;
-(void) update:(ccTime)delta;
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

@end
