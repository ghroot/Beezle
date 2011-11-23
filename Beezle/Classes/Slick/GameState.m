//
//  GameState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "GameContainer.h"
#import "StateBasedGame.h"

@implementation GameState

@synthesize stateId = _stateId;

-(id) initWithId:(int)stateId
{
    if (self = [super init])
    {
		_stateId = stateId;
    }
    return self;
}

-(void) initialiseWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
}

-(void) enterWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
}

-(void) updateWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game delta:(int)delta
{
}

-(void) renderWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
}

-(void) leaveWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
}

@end
