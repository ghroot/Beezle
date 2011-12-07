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

-(id) init
{
    if (self = [super init])
    {
		[self scheduleUpdate];
    }
    return self;
}

-(void) dealloc
{
	[self unscheduleUpdate];
	
	[super dealloc];
}

+(id) state
{
	return [[[self alloc] init] autorelease];
}

-(void) update:(ccTime)delta
{
}

-(void) draw
{
}

@end
