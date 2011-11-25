/**
* Based on parts of Slick(tm) game engine
* 
* Copyright (c) 2007, Slick 2D
* 
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* * Neither the name of the Slick 2D nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
* A PARTICULAR PURPOSE ARE * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR * * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
* TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE * * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "GameContainer.h"
#import "Game.h"

@interface GameContainer()

-(void) timerInterval:(NSTimer *)timer;

@end

@implementation GameContainer

@synthesize updateInterval = _updateInterval;
@synthesize paused = _paused;

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
	_timer = [NSTimer scheduledTimerWithTimeInterval:_updateInterval target:self selector:@selector(timerInterval:) userInfo:nil repeats:TRUE];    
}

-(void) timerInterval:(NSTimer *)timer
{
	[self update:(int) (1000 * _updateInterval)];
    [self render];
}

-(void) setup
{
    [_game initialiseWithContainer:self];
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
    if (_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
	
	_running = FALSE;
}

@end
