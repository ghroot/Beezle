//
//  PausedDialog.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 07/28/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PausedDialog.h"
#import "LevelSession.h"
#import "PlayerInformation.h"
#import "PausedMenuState.h"

@interface PausedDialog()

-(void) resumeGame;
-(void) restartGame;
-(void) nextLevel;

@end

@implementation PausedDialog

-(id) initWithState:(PausedMenuState *)state andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"PausedDialog.ccbi"])
	{
		_state = state;
		_levelSession = levelSession;

		[_levelPollenCountLabel setString:[NSString stringWithFormat:@"%d", [levelSession totalNumberOfPollen]]];
		[_totalPollenCountLabel setString:[NSString stringWithFormat:@"%d", [[PlayerInformation sharedInformation] totalNumberOfPollen]]];
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
