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

#ifdef DEBUG
static NSString *TEST_FLIGHT_TOKEN = @"ae396bc6dbee18a35a1087713acb890b_ODQ5NTEyMDEyLTA0LTI2IDE5OjE0OjM3LjYyMDc3NQ";
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

#ifdef DEBUG
	// TestFlight
	[TestFlight takeOff:TEST_FLIGHT_TOKEN];
#endif

	// Google analytics
	[[GAI sharedInstance] setTrackUncaughtExceptions:TRUE];
	[[GAI sharedInstance] setDispatchInterval:20];
#ifdef DEBUG
	[[GAI sharedInstance] setDebug:TRUE];
#endif
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

@end
