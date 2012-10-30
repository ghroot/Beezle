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

static NSString *FLURRY_ANALYTICS_TOKEN = @"R5JM67WQ5K522SHSW925";
static NSString *TEST_FLIGHT_TOKEN = @"ae396bc6dbee18a35a1087713acb890b_ODQ5NTEyMDEyLTA0LTI2IDE5OjE0OjM3LjYyMDc3NQ";

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
	[TestFlight takeOff:TEST_FLIGHT_TOKEN];
}

-(void) trackStartedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_STARTED" withParameters:parameters];
}

-(void) trackCompletedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_COMPLETED" withParameters:parameters];
}

-(void) trackFailedLevel:(NSString *)levelName
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:levelName forKey:@"levelName"];
	[Flurry logEvent:@"LEVEL_FAILED" withParameters:parameters];
}

@end
