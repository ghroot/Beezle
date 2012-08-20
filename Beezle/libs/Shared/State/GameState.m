//
//  GameState.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "Game.h"

@implementation GameState

@synthesize game = _game;
@synthesize isInitalised = _isInitialised;
@synthesize needsLoadingState = _needsLoadingState;

+(id) state
{
	return [[[self alloc] init] autorelease];
}

-(id) init
{
	if (self = [super init])
	{
		_isInitialised = FALSE;
		_needsLoadingState = FALSE;
	}
	return self;
}

-(void) initialise
{
	_isInitialised = TRUE;
}

-(void) enter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:FALSE];
    [self scheduleUpdate];
}

-(void) leave
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleUpdate]; 
}

-(void) update:(ccTime)delta
{
}

-(void) draw
{
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
