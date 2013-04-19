//
//  SessionTracker.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionTracker.h"
#import "TestFlight.h"
#import "Flurry.h"
#import "GAI.h"

#ifdef LITE_VERSION
  #ifdef DEVELOPMENT
static NSString *FLURRY_ANALYTICS_TOKEN = @"V3GG4GT62DG6J6BV6CDJ";
  #else
static NSString *FLURRY_ANALYTICS_TOKEN = @"QZ935N6MX7FB84PG6XDR";
  #endif
#else
  #ifdef DEVELOPMENT
static NSString *FLURRY_ANALYTICS_TOKEN = @"6FSC8Y9JFX4ZQNRJ3NDZ";
  #else
static NSString *FLURRY_ANALYTICS_TOKEN = @"R5JM67WQ5K522SHSW925";
  #endif
#endif

#ifdef LITE_VERSION
  #ifdef DEVELOPMENT
static NSString *TEST_FLIGHT_TOKEN = @"d35af6e1-d2ad-4b75-9280-113fd33480f0";
  #else
static NSString *TEST_FLIGHT_TOKEN = @"ff63f3f1-a9de-4b4a-8418-04c5d6896d19";
  #endif
#else
  #ifdef DEVELOPMENT
static NSString *TEST_FLIGHT_TOKEN = @"67541518-ef6d-4f16-a58f-0400938531b0";
  #else
static NSString *TEST_FLIGHT_TOKEN = @"c9e388f1-9619-44b1-8e46-3f6b605499c0";
  #endif
#endif

#ifdef LITE_VERSION
  #ifdef DEVELOPMENT
static NSString *GOOGLE_ANALYTICS_TRACKING_ID = @"UA-36666042-4";
  #else
static NSString *GOOGLE_ANALYTICS_TRACKING_ID = @"UA-36666042-2";
  #endif
#else
  #ifdef DEVELOPMENT
static NSString *GOOGLE_ANALYTICS_TRACKING_ID = @"UA-36666042-3";
  #else
static NSString *GOOGLE_ANALYTICS_TRACKING_ID = @"UA-36666042-1";
  #endif
#endif

void uncaughtExceptionHandler(NSException *exception)
{
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@implementation SessionTracker

+(SessionTracker *) sharedTracker
{
    static SessionTracker *tracker = 0;
    if (!tracker)
    {
        tracker = [[self alloc] init];
    }
    return tracker;
}

-(void) start
{
	// Flurry
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [Flurry startSession:FLURRY_ANALYTICS_TOKEN];

	// TestFlight
#ifdef DEVELOPMENT
	[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
	[TestFlight takeOff:TEST_FLIGHT_TOKEN];
#endif

	// Google analytics
	[[GAI sharedInstance] setTrackUncaughtExceptions:TRUE];
	[[GAI sharedInstance] setDispatchInterval:20];
	[[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS_TRACKING_ID];
}

-(void) trackStartedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_STARTED" withParameters:parameters];

	[[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"level" withAction:@"started" withLabel:levelName withValue:[NSNumber numberWithInt:0]];
}

-(void) trackCompletedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_COMPLETED" withParameters:parameters];

	[[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"level" withAction:@"completed" withLabel:levelName withValue:[NSNumber numberWithInt:0]];
}

-(void) trackFailedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_FAILED" withParameters:parameters];

	[[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"level" withAction:@"failed" withLabel:levelName withValue:[NSNumber numberWithInt:0]];
}

-(void) trackInteraction:(NSString *)type name:(NSString *)interactionName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:interactionName forKey:@"interactionName"];
	[Flurry logEvent:@"INTERACTION" withParameters:parameters];

	[[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"interaction" withAction:type withLabel:interactionName withValue:[NSNumber numberWithInt:0]];
}

-(void) trackScreen:(NSString *)screenName
{
	[[[GAI sharedInstance] defaultTracker] trackView:screenName];
}

@end
