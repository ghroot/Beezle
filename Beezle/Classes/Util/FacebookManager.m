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


-(void) login
{
	[FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:TRUE completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
		if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening){
			[[FBSession activeSession] closeAndClearTokenInformation];
			[FBSession setActiveSession:nil];

			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Facebook login failed: %@", [error localizedDescription]]];
		}
		else
		{
			_facebook = [[Facebook alloc] initWithAppId:[[FBSession activeSession] appID] andDelegate:nil];
			[_facebook setAccessToken:[[FBSession activeSession] accessToken]];
			[_facebook setExpirationDate:[[FBSession activeSession] expirationDate]];

			[self requestUserInformation];
		}
	}];
}

-(void) dealloc
{
	[_facebook release];
	[_playerName release];

	[super dealloc];
}

-(void) requestUserInformation
{
	[[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error){
		if (!error && result)
		{
			_playerFBID = [[result id] longLongValue];
			_playerName = [[result first_name] copy];

			[[Logger defaultLogger] log:@"Facebook login successful!"];

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
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Facebook user info request failed: %@", [error localizedDescription]]];
		}
	}];
}

-(void) postScore:(int)score
{
	if (!_isLoggedIn)
	{
		return;
	}

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Posting score to Facebook: %d", score]];
#endif

	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", score], @"score", nil];
	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores", _playerFBID] parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
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
		return;
	}

	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores?fields=score,user", APP_ID] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
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
		}
		else
		{
			if (_delegate != nil)
			{
				[_delegate failedToGetScores];
			}
		}
	}];
}

@end
