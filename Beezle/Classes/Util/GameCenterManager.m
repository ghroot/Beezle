//
// Created by Marcus on 13/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GameCenterManager.h"
#import "cocos2d.h"
#import "Logger.h"
#import "PlayerInformation.h"

#ifdef DEVELOPMENT
static NSString *LEADERBOARD_ID = @"collectedPollenDevelopment";
#else
static NSString *LEADERBOARD_ID = @"collectedPollen";
#endif

@interface GameCenterManager()

-(void) authenticationSuccessful;
-(void) authenticationFailed;

@end

@implementation GameCenterManager

@synthesize isAuthenticated = _isAuthenticated;

+(GameCenterManager *) sharedManager
{
	static GameCenterManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) authenticate
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
	if ([localPlayer respondsToSelector:@selector(setAuthenticateHandler:)])
	{
		[localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error){
			if (viewController != nil)
			{
				[[CCDirector sharedDirector] presentViewController:viewController animated:TRUE completion:nil];

				[[Logger defaultLogger] log:@"Showing GameCenter authentication dialog"];
			}
			else if ([localPlayer isAuthenticated])
			{
				[self authenticationSuccessful];
			}
			else
			{
				[self authenticationFailed];
			}
#ifdef DEBUG
			if (error != nil)
			{
				[[Logger defaultLogger] log:[error localizedDescription]];
			}
#endif
		}];
	}
	else
	{
		[localPlayer authenticateWithCompletionHandler:^(NSError *error){
			if ([localPlayer isAuthenticated])
			{
				[self authenticationSuccessful];
			}
			else
			{
				[self authenticationFailed];
			}
#ifdef DEBUG
			if (error != nil)
			{
				[[Logger defaultLogger] log:[error localizedDescription]];
			}
#endif
		}];
	}
}

-(void) authenticationSuccessful
{
	_isAuthenticated = TRUE;

	if (![[PlayerInformation sharedInformation] autoAuthenticateGameCenter])
	{
		[[PlayerInformation sharedInformation] setAutoAuthenticateGameCenter:TRUE];
		[[PlayerInformation sharedInformation] save];
	}

#ifdef DEBUG
	[[Logger defaultLogger] log:@"GameCenter authenticated"];
#endif

	if (_showLeaderBoardsOnceAuthenticated)
	{
		_showLeaderBoardsOnceAuthenticated = FALSE;
		[self showLeaderboards];
	}
}

-(void) authenticationFailed
{
#ifdef DEBUG
	[[Logger defaultLogger] log:@"GameCenter failed to authenticate"];
#endif

	_showLeaderBoardsOnceAuthenticated = FALSE;
}

-(void) showLeaderboards
{
	if (_isAuthenticated)
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
				if ([[CCDirector sharedDirector] respondsToSelector:@selector(presentViewController:animated:completion:)])
				{
					[[CCDirector sharedDirector] presentViewController:leaderboardController animated:TRUE completion:nil];
				}
				else
				{
					[[CCDirector sharedDirector] presentModalViewController:leaderboardController animated:TRUE];
				}
				[leaderboardController release];
			}
		}
	}
	else
	{
		_showLeaderBoardsOnceAuthenticated = TRUE;

		[self authenticate];
	}
}

-(void) reportScore:(int)score
{
	if (!_isAuthenticated)
	{
		return;
	}

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Reporting score to game center: %d", score]];
#endif

	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:LEADERBOARD_ID] autorelease];
	[scoreReporter setValue:score];
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error){
#ifdef DEBUG
		if (error != nil)
		{
			[[Logger defaultLogger] log:[error localizedDescription]];
		}
#endif
	}];
}

-(void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
	[[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];

	[[CCDirector sharedDirector] setNextDeltaTimeZero:TRUE];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	if ([[CCDirector sharedDirector] respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
	{
		[[CCDirector sharedDirector] dismissViewControllerAnimated:TRUE completion:nil];
	}
	else
	{
		[[CCDirector sharedDirector] dismissModalViewControllerAnimated:TRUE];
	}

	[[CCDirector sharedDirector] setNextDeltaTimeZero:TRUE];
}

@end
