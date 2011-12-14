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

+(id) state
{
	return [[[self alloc] init] autorelease];
}

-(void) enter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:TRUE];
    [self scheduleUpdate];
}

-(void) leave
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
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