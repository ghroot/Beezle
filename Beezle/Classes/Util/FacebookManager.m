//
//  FacebookManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Accounts/Accounts.h>
#import "FacebookManager.h"
#import "Logger.h"
#import "PlayerInformation.h"
#import "ApplicationIds.h"

@interface FacebookManager()

-(BOOL) hasNativeIntegration;
-(void) handleLoginResult:(FBSession *)session status:(FBSessionState)status error:(NSError *)error;
-(void) postScore:(int)score;

@end

@implementation FacebookManager

@synthesize isLoggedIn = _isLoggedIn;
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

	[super dealloc];
}

-(void) login
{
	if (_isLoggedIn)
	{
		[_delegate didLogin];
		return;
	}

	if ([self hasNativeIntegration])
	{
		// iOS6 with facebook account, can only request read permissions
		[FBSession openActiveSessionWithReadPermissions:[NSArray array] allowLoginUI:TRUE completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
			[self handleLoginResult:session status:status error:error];
		}];
	}
	else
	{
		[FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:TRUE completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
			[self handleLoginResult:session status:status error:error];
		}];
	}
}

-(void) handleLoginResult:(FBSession *)session status:(FBSessionState)status error:(NSError *)error
{
	// NOTE: Due to a bug in the Facebook SDK this function is called after asking for permissions too. If
	// we are already logged in we simply ignore this callback.
	if (_isLoggedIn)
	{
		return;
	}

	if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening){
#ifdef DEBUG
		[[Logger defaultLogger] log:[NSString stringWithFormat:@"Facebook login failed: %@", [error localizedDescription]]];
#endif

		[[FBSession activeSession] closeAndClearTokenInformation];
		[FBSession setActiveSession:nil];

		[_delegate loginFailed];
	}
	else
	{
#ifdef DEBUG
		[[Logger defaultLogger] log:@"Facebook logged in"];
#endif

		_facebook = [[Facebook alloc] initWithAppId:[[FBSession activeSession] appID] andDelegate:nil];
		[_facebook setAccessToken:[[FBSession activeSession] accessToken]];
		[_facebook setExpirationDate:[[FBSession activeSession] expirationDate]];

		for (NSString *permission in [session permissions])
		{
			if ([permission isEqualToString:@"publish_actions"])
			{
				_hasPublishPermission = TRUE;
			}
		}

#ifdef DEBUG
		[[Logger defaultLogger] log:[NSString stringWithFormat:@"Has Facebook publish permissions: %@", (_hasPublishPermission ? @"true" : @"false")]];
#endif
		
		_isLoggedIn = TRUE;

		[_delegate didLogin];

		if (![[PlayerInformation sharedInformation] autoLoginToFacebook])
		{
			[[PlayerInformation sharedInformation] setAutoLoginToFacebook:TRUE];
			[[PlayerInformation sharedInformation] save];
		}
	}
}

-(BOOL) hasNativeIntegration
{
	ACAccountStore *accountStore = [[ACAccountStore new] autorelease];
	ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:@"com.apple.facebook"];
	return accountType != nil;
}

-(void) closeSession
{
	[[FBSession activeSession] close];
}

-(void) getScores
{
	if (!_isLoggedIn)
	{
		[_delegate failedToGetScores];
		return;
	}

	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%llu/scores?fields=score,user", FACEBOOK_APPLICATION_ID] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
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

			[_delegate didRecieveUids:uids names:names scores:scores];

#ifdef DEBUG
			[[Logger defaultLogger] log:@"Getting Facebook scores succeeeded"];
#endif
		}
		else
		{
			[_delegate failedToGetScores];

#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Getting Facebook scores failed: %@", [error localizedDescription]]];
#endif
		}
	}];
}

-(void) tryPostScore:(int)score
{
	if (!_isLoggedIn)
	{
		[_delegate failedToPostScore];
		return;
	}

	if (_hasPublishPermission)
	{
		[self postScore:score];
	}
	else if ([self hasNativeIntegration])
	{
		// iOS6 with facebook account, have to request publish permission
		[[FBSession activeSession] reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error){
			if (!error)
			{
				for (NSString *permission in [session permissions])
				{
					if ([permission isEqualToString:@"publish_actions"])
					{
						_hasPublishPermission = TRUE;
					}
				}

#ifdef DEBUG
				[[Logger defaultLogger] log:[NSString stringWithFormat:@"Has Facebook publish permissions: %@", (_hasPublishPermission ? @"true" : @"false")]];
#endif

				[self postScore:score];
			}
			else
			{
#ifdef DEBUG
				[[Logger defaultLogger] log:@"No Facebook permission to post score"];
#endif

				[_delegate failedToPostScore];
			}
		}];
	}
	else
	{
		[_delegate failedToPostScore];
	}
}

-(void) postScore:(int)score
{
	if (!_isLoggedIn)
	{
		[_delegate failedToPostScore];
		return;
	}

	if (!_hasPublishPermission)
	{
#ifdef DEBUG
		[[Logger defaultLogger] log:@"No Facebook permission to post score"];
#endif

		[_delegate failedToPostScore];

		return;
	}

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Posting score to Facebook: %d", score]];
#endif

	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", score], @"score", nil];
	[FBRequestConnection startWithGraphPath:@"me/scores" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
		if (result && !error)
		{
			int currentScore = 0;

			NSArray *data = [result objectForKey:@"data"];
			if ([data count] > 0)
			{
				currentScore = [[[data objectAtIndex:0] objectForKey:@"score"] intValue];
			}

			if (score > currentScore) {

				[FBRequestConnection startWithGraphPath:@"me/scores" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
					if (result && !error)
					{
#ifdef DEBUG
						[[Logger defaultLogger] log:@"Facebook score posted"];
#endif
					}
					else
					{
#ifdef DEBUG
						[[Logger defaultLogger] log:[NSString stringWithFormat:@"Error posting Facebook score: %@", [error localizedDescription]]];
#endif

						[_delegate failedToPostScore];
					}
				}];
			}
			else
			{
#ifdef DEBUG
				[[Logger defaultLogger] log:@"No need to post Facebook score"];
#endif
			}
		}
		else
		{
#ifdef DEBUG
			[[Logger defaultLogger] log:[NSString stringWithFormat:@"Error posting Facebook score: %@", [error localizedDescription]]];
#endif

			[_delegate failedToPostScore];
		}
	}];
}

-(void) handleOpenURL:(NSURL *)url
{
	[[FBSession activeSession] handleOpenURL:url];
}

@end
