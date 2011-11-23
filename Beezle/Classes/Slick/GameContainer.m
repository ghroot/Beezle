//
//  GameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameContainer.h"

@interface GameContainer()

-(void) timerInterval;

@end

@implementation GameContainer

-(id) initWithGame:(Game *)game
{
    if (self = [super init])
    {
		_game = game;
		[_game setContainer:self];
    }
    return self;
}

-(void) start
{
	_running = TRUE;

	float interval = 1.0f/60.0f;
	_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:timerInterval userInfo:nil repeats:TRUE];
}

-(void) timerInterval
{
	float delta = 1.0f/60.0f;
	[self updateAndRender:delta];
}

-(void) updateAndRender:(int)delta
{
	if (_running)
	{
		if (!_paused)
		{
			[_game update:delta];
		}
		else
		{
			[_game update:0];
		}
	}
	[_game render];
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
