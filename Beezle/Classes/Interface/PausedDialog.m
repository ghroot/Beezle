//
//  PausedDialog.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 07/28/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PausedDialog.h"
#import "LevelSession.h"
#import "PausedMenuState.h"

@implementation PausedDialog

-(id) initWithState:(PausedMenuState *)state andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"PausedDialog.ccbi" andLevelSession:levelSession])
	{
		_state = state;

		[self useOrangeResumeButton];
		[self useWhiteRestartButton];
		[self useNoNextLevelButton];
	}
	return self;
}

-(void) resumeGame
{
	[_state resumeGame];
}

-(void) restartGame
{
	[_state restartGame];
}

-(void) nextLevel
{
	[_state nextLevel];
}

@end
