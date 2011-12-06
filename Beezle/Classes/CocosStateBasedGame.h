//
//  CocosStateBasedGame.h
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "slick.h"

@interface CocosStateBasedGame : StateBasedGame
{
	NSMutableArray *_stateStack;
}

-(void) enterStateKeepCurrent:(int)stateId;
-(void) enterStateDiscardPrevious:(int)stateId;
-(void) enterPreviousState;

@end
