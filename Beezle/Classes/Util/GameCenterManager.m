//
// Created by Marcus on 13/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GameCenterManager.h"
#import "cocos2d.h"
#import "Logger.h"

static NSString *LEADERBOARD_ID = @"default";

@implementation GameCenterManager

+(GameCenterManager *) sharedManager
{
	static GameCenterManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) initialise
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	[localPlayer authenticateWithCompletionHandler:^(NSError *error){
		if ([localPlayer isAuthenticated])
		{
			_isAuthenticated = TRUE;
		}
#ifdef DEBUG
		if (error != nil)
		{
			[[Logger defaultLogger] log:[error localizedDescription]];
		}
#endif
	}];
}

-(void) showLeaderboards
{
	if ([GKGameCenterViewController class])
	{
		GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
		if (gameCenterController != nil)
		{
			[gameCenterController setGameCenterDelegate:self];
			[gameCenterController setViewState:GKGameCenterViewControllerStateLeaderboards];
			[gameCenterController setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
			[gameCenterController setLeaderboardCategory:LEADERBOARD_ID];
			[[CCDirector sharedDirector] presentViewController:gameCenterController animated:TRUE completion:nil];
			[gameCenterController release];
		}
	}
	else
	{
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
		if (leaderboardController != nil)
		{
			[leaderboardController setLeaderboardDelegate:self];
			[leaderboardController setTimeScope:GKLeaderboardTimeScopeAllTime];
			[leaderboardController setCategory:LEADERBOARD_ID];
			[[CCDirector sharedDirector] presentViewController:leaderboardController animated:TRUE completion:nil];
			[leaderboardController release];
		}
	}
}

-(void) reportScore:(int)score
{
	if (_isAuthenticated)
	{
#ifdef DEBUG
		[[Logger defaultLogger] log:@"Reporting score to game center"];
#endif

		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:LEADERBOARD_ID] autorelease];
		[scoreReporter setValue:score];
		[scoreReporter setContext:0];

		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error){
#ifdef DEBUG
			if (error != nil)
			{
				[[Logger defaultLogger] log:[error localizedDescription]];
			}
#endif
		}];
	}
}

-(void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
	[[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

@end
