//
// Created by Marcus on 2013-10-26.
//

#import "PausedMode.h"
#import "GameplayState.h"

@implementation PausedMode

-(void) enter
{
	[super enter];

	[_gameplayState hidePauseButton];
}

-(void) leave
{
	[super enter];

	[_gameplayState showPauseButton];
}

@end
