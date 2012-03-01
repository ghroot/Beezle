//
//  Game.h
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class GameState;

@interface Game : NSObject
{
    NSMutableArray *_gameStateStack;
}

-(void) startWithState:(GameState *)gameState;
-(void) replaceState:(GameState *)gameState;
-(void) replaceState:(GameState *)gameState withTransition:(Class)transitionClass duration:(float)duration;
-(void) pushState:(GameState *)gameState;
-(void) popState;
-(void) popAndReplaceState:(GameState *)gameState;
-(GameState *) currentState;

@end
