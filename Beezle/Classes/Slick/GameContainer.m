//
//  GameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameContainer.h"
#import "Game.h"

@interface GameContainer()

-(void) timerInterval:(NSTimer *)timer;

@end

@implementation GameContainer

-(id) initWithGame:(Game *)game
{
    if (self = [super init])
    {
		_game = game;
    }
    return self;
}

-(void) start
{
    [self setup];
    
	_running = TRUE;
    
    [self startInterval];
}

-(void) startInterval
{
	float interval = 1.0f/60.0f;
	_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerInterval:) userInfo:nil repeats:TRUE];    
}

-(void) setup
{
    [_game initialiseWithContainer:self];
}

-(void) timerInterval:(NSTimer *)timer
{
	float delta = 1.0f/60.0f;
	[self update:delta];
    [self render];
}

-(void) update:(int)delta
{
	if (_running)
	{
		if (!_paused)
		{
			[_game updateWithContainer:self andDelta:delta];
		}
		else
		{
			[_game updateWithContainer:self andDelta:0];
		}
	}
}

-(void) render
{
    [_game renderWithContainer:self];
}

-(void) pause
{
	_paused = TRUE;
}

-(void) resume
{
	_paused = FALSE;
}

-(void) exit
{
	[_timer invalidate];
	_timer = nil;
	
	_running = FALSE;
}

@end
