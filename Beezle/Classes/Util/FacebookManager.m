//
//  FacebookManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "Logger.h"
#import "PlayerInformation.h"

static const long long APP_ID = 392888574136437;

@interface FacebookManager()

-(void) getSession;
-(void) requestUserInformation;

@end

@implementation FacebookManager

@synthesize isLoggedIn = _isLoggedIn;
@synthesize playerFBID = _playerFBID;
@synthesize delegate = _delegate;

+(FacebookManager *) sharedManager
{
	static FacebookManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(id) init
{
	if (self = [super init])
	{
		FBSession *session = [[[FBSession alloc] init] autorelease];
		[FBSession setActiveSession:session];
	}
	return self;
}

-(void) dealloc
{
	[_facebook release];
	[_playerName release];

	[super dealloc];
}

-(void) login
{
	if (_isLoggedIn)
	{
		if (_delegate != nil)
		{
			[_delegate didLogin];
		}
		return;
	}

	if (_isRequestInProgress)
	{
		return;
	}

	if (_hasSession)
	{
		[self requestUserInformation];
	}
	else
	{
		[self getSession];
	}
}

-(void) getSession
{
	_isRequestInProgress = TRUE;

	[FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:TRUE completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
		_isRequestInProgress = FALSE;
		if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening){
#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Getting Facebook session failed: %@", [error localizedDescription]]];
#endif

			[[FBSession activeSession] closeAndClearTokenInformation];
			[FBSession setActiveSession:nil];

			if (_delegate != nil)
			{
				[_delegate loginFailed];
			}
		}
		else
		{
#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Getting Facebook session succeeeded"]];
#endif

			_facebook = [[Facebook alloc] initWithAppId:[[FBSession activeSession] appID] andDelegate:nil];
			[_facebook setAccessToken:[[FBSession activeSession] accessToken]];
			[_facebook setExpirationDate:[[FBSession activeSession] expirationDate]];

			_hasSession = TRUE;

			[self requestUserInformation];
		}
	}];
}

-(void) requestUserInformation
{
	_isRequestInProgress = TRUE;

	[[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error){
		_isRequestInProgress = FALSE;
		if (!error && result)
		{
#ifdef DEBUG
			[[Logger defaultLogger] log:@"Facebook user info request successful"];
			[[Logger defaultLogger] log:@"Facebook login completed"];
#endif

			_playerFBID = [[result id] longLongValue];
			_playerName = [[result first_name] copy];

			_isLoggedIn = TRUE;

			if (_delegate != nil)
			{
				[_delegate didLogin];
			}

			if (![[PlayerInformation sharedInformation] autoLoginToFacebook])
			{
				[[PlayerInformation sharedInformation] setAutoLoginToFacebook:TRUE];
				[[PlayerInformation sharedInformation] save];
			}
		}
		else
		{
#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Facebook user info request failed: %@", [error localizedDescription]]];
#endif

			if (_delegate != nil)
			{
				[_delegate loginFailed];
			}
		}
	}];
}

-(void) closeSession
{
	[[FBSession activeSession] close];
}

-(void) postScore:(int)score
{
	if (!_isLoggedIn ||
		_isRequestInProgress)
	{
		return;
	}

	_isRequestInProgress = TRUE;

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Posting score to Facebook: %d", score]];
#endif

	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", score], @"score", nil];
	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores", _playerFBID] parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
		_isRequestInProgress = FALSE;
		if (result && !error)
		{
			int currentScore = 0;

			NSArray *data = [result objectForKey:@"data"];
			if ([data count] > 0)
			{
				currentScore = [[[data objectAtIndex:0] objectForKey:@"score"] intValue];
			}

			if (score > currentScore) {

				[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores", _playerFBID] parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
#ifdef DEBUG
					if (result && !error)
					{
						[[Logger defaultLogger] log:@"Facebook score posted"];
					}
					else
					{
						[[Logger defaultLogger] log:[NSString stringWithFormat:@"Error posting Facebook score: %@", [error localizedDescription]]];
					}
#endif
				}];
			}
			else
			{
#ifdef DEBUG
				[[Logger defaultLogger] log:@"No need to post Facebook score"];
#endif
			}
		}
	}];
}

-(void) getScores
{
	if (!_isLoggedIn)
	{
		if (_delegate != nil)
		{
			[_delegate failedToGetScores];
		}
		return;
	}

	if (_isRequestInProgress)
	{
		return;
	}

	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores?fields=score,user", APP_ID] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
		_isRequestInProgress = FALSE;
		if (result && !error)
		{
			NSMutableArray *uids = [NSMutableArray array];
			NSMutableArray *names = [NSMutableArray array];
			NSMutableArray *scores = [NSMutableArray array];

			for (NSDictionary *dict in [result objectForKey:@"data"])
			{
				NSString *uid = [[dict objectForKey:@"user"] objectForKey:@"id"];
				NSString *name = [[dict objectForKey:@"user"] objectForKey:@"name"];
				NSDecimalNumber *scoreNumber = [dict objectForKey:@"score"];
				NSString *score = [NSString stringWithFormat:@"%d", [scoreNumber intValue]];

				[uids addObject:uid];
				[names addObject:name];
				[scores addObject:score];
			}

			if (_delegate != nil)
			{
				[_delegate didRecieveUids:uids names:names scores:scores];
			}

#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Getting Facebook scores succeeeded"]];
#endif
		}
		else
		{
			if (_delegate != nil)
			{
				[_delegate failedToGetScores];
			}

#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Getting Facebook scores failed: %@", [error localizedDescription]]];
#endif
		}
	}];
}

-(void) handleOpenURL:(NSURL *)url
{
	[[FBSession activeSession] handleOpenURL:url];
}

@end
