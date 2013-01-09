//
//  PlayerInformation.m
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "Logger.h"
#import "GameCenterManager.h"

static NSString *SETTINGS_KEY = @"Settings";
static NSString *PROGRESS_KEY = @"Progress";

@interface PlayerInformation()

-(void) cloudDataDidChange:(NSNotification *)notification;
-(void) load;
-(NSDictionary *) getSettingsAsDictionary;
-(NSDictionary *) getProgressAsDictionary;
-(BOOL) hasCompletedLevelAtLeastOnce:(NSString *)levelName;

@end

@implementation PlayerInformation

@synthesize isSoundMuted = _isSoundMuted;
@synthesize usingAdvancedControlScheme = _usingAdvancedControlScheme;

+(PlayerInformation *) sharedInformation
{
    static PlayerInformation *information = 0;
    if (!information)
    {
        information = [[self alloc] init];
    }
    return information;
}

-(id) init
{
	if (self = [super init])
	{
		_pollenRecordByLevelName = [NSMutableDictionary new];
		_seenTutorialIds = [NSMutableSet new];
	}
	return self;
}

-(void) dealloc
{
#ifndef LITE_VERSION
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#endif

	[_pollenRecordByLevelName release];
	[_seenTutorialIds release];
	[_defaultTheme release];
	
	[super dealloc];
}

-(void) initialise
{
	[self load];

#ifndef LITE_VERSION
#ifdef DEBUG
	[[Logger defaultLogger] log:@"Synchronizing iCloud..."];
#endif
	NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	if (store != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDataDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:store];
		[store synchronize];
	}
#endif
}

-(void) cloudDataDidChange:(NSNotification *)notification
{
#ifdef DEBUG
	[[Logger defaultLogger] log:@"iCloud data recieved."];
#endif

	NSDictionary *userInfo = [notification userInfo];
	NSNumber *reason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
	if (reason != nil)
	{
		NSInteger reasonValue = [reason integerValue];
		if (reasonValue == NSUbiquitousKeyValueStoreInitialSyncChange ||
				reasonValue == NSUbiquitousKeyValueStoreServerChange)
		{
			NSArray *keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
			for (NSString *key in keys)
			{
				if ([key isEqualToString:PROGRESS_KEY])
				{
					NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
					NSDictionary *cloudDict = [store objectForKey:key];
					NSDictionary *cloudPollenRecordByLevelName = [cloudDict objectForKey:@"pollenRecordByLevelName"];
					for (NSString *levelName in [cloudPollenRecordByLevelName allKeys])
					{
						int localRecord = [[_pollenRecordByLevelName objectForKey:levelName] intValue];
						int cloudRecord = [[cloudPollenRecordByLevelName objectForKey:levelName] intValue];
						if (cloudRecord > localRecord)
						{
							[_pollenRecordByLevelName setObject:[NSNumber numberWithInt:cloudRecord] forKey:levelName];
						}
					}
					NSArray *cloudSeenTutorialIds = [cloudDict objectForKey:@"seenTutorialIds"];
					for (NSString *cloudSeenTutorialId in cloudSeenTutorialIds)
					{
						if (![_seenTutorialIds containsObject:cloudSeenTutorialId])
						{
							[_seenTutorialIds addObject:cloudSeenTutorialId];
						}
					}
					if ([cloudDict objectForKey:@"defaultTheme"] != nil)
					{
						_defaultTheme = [[cloudDict objectForKey:@"defaultTheme"] copy];
					}
				}
			}
		}
	}
}

-(void) save
{
	[[NSUserDefaults standardUserDefaults] setObject:[self getSettingsAsDictionary] forKey:SETTINGS_KEY];
	[[NSUserDefaults standardUserDefaults] setObject:[self getProgressAsDictionary] forKey:PROGRESS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];

#ifndef LITE_VERSION
#ifdef DEBUG
	[[Logger defaultLogger] log:@"Saving to iCloud..."];
#endif
	NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	if (store != nil)
	{
		[store setObject:[self getProgressAsDictionary] forKey:PROGRESS_KEY];
	}
#endif
}

-(void) load
{
	NSDictionary *settingsDict = [[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_KEY];
	if (settingsDict != nil)
	{
		_isSoundMuted = [[settingsDict objectForKey:@"isSoundMuted"] boolValue];
		_usingAdvancedControlScheme = [[settingsDict objectForKey:@"usingAdvancedControlScheme"] boolValue];
	}
	NSDictionary *progressDict = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_KEY];
	if (progressDict != nil)
	{
		[_pollenRecordByLevelName addEntriesFromDictionary:[progressDict objectForKey:@"pollenRecordByLevelName"]];
		[_seenTutorialIds addObjectsFromArray:[progressDict objectForKey:@"seenTutorialIds"]];
		_defaultTheme = [[progressDict objectForKey:@"defaultTheme"] copy];
	}
}

-(void) reset
{
	[_pollenRecordByLevelName removeAllObjects];
	[_seenTutorialIds removeAllObjects];
	[_defaultTheme release];
	_defaultTheme = nil;
	_isSoundMuted = FALSE;
	_usingAdvancedControlScheme = FALSE;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:SETTINGS_KEY];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:PROGRESS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];

#ifndef LITE_VERSION
#ifdef DEBUG
	[[Logger defaultLogger] log:@"Resetting iCloud data..."];
#endif
	NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	if (store != nil)
	{
		[store removeObjectForKey:PROGRESS_KEY];
	}
#endif
}

-(NSDictionary *) getSettingsAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithBool:_isSoundMuted] forKey:@"isSoundMuted"];
	[dict setObject:[NSNumber numberWithBool:_usingAdvancedControlScheme] forKey:@"usingAdvancedControlScheme"];
	return dict;
}

-(NSDictionary *) getProgressAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSDictionary dictionaryWithDictionary:_pollenRecordByLevelName] forKey:@"pollenRecordByLevelName"];
	[dict setObject:[_seenTutorialIds allObjects] forKey:@"seenTutorialIds"];
	if (_defaultTheme != nil)
	{
		[dict setObject:_defaultTheme forKey:@"defaultTheme"];
	}
	return dict;
}

-(void) store:(LevelSession *)levelSession
{
	if ([self isPollenRecord:levelSession])
	{
		[_pollenRecordByLevelName setObject:[NSNumber numberWithInt:[levelSession totalNumberOfPollen]] forKey:[levelSession levelName]];

#ifndef LITE_VERSION
		[[GameCenterManager sharedManager] reportScore:[self totalNumberOfPollen]];
#endif
	}
}

-(void) storeAndSave:(LevelSession *)levelSession
{
	[self store:levelSession];
	[self save];
}

-(BOOL) isPollenRecord:(LevelSession *)levelSession
{
	return [levelSession totalNumberOfPollen] > [self pollenRecord:[levelSession levelName]];
}

-(int) pollenRecord:(NSString *)levelName
{
	if ([_pollenRecordByLevelName objectForKey:levelName] != nil)
	{
		return [[_pollenRecordByLevelName objectForKey:levelName] intValue];
	}
	else
	{
		return 0;
	}
}

-(int) totalNumberOfPollen
{
	int total = 0;
	for (NSNumber *pollenRecord in [_pollenRecordByLevelName allValues])
	{
		total += [pollenRecord intValue];
	}
	return total;
}

-(int) flowerRecordForLevel:(NSString *)levelName
{
	LevelLayout *layout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	int pollenRecord = [self pollenRecord:levelName];
	if (pollenRecord == 0)
	{
		return 0;
	}
	else if (pollenRecord >= [layout pollenForThreeFlowers])
	{
		return 3;
	}
	else if (pollenRecord >= [layout pollenForTwoFlowers])
	{
		return 2;
	}
	else
	{
		return 1;
	}
}

-(int) flowerRecordForTheme:(NSString *)theme
{
	int total = 0;
	for (NSString *levelName in [[LevelOrganizer sharedOrganizer] levelNamesInTheme:theme])
	{
		total += [self flowerRecordForLevel:levelName];
	}
	return total;
}

-(int) totalNumberOfFlowers
{
	int total = 0;
	for (NSString *levelName in [_pollenRecordByLevelName allKeys])
	{
		total += [self flowerRecordForLevel:levelName];
	}
	return total;
}

-(BOOL) hasCompletedLevelAtLeastOnce:(NSString *)levelName
{
    return [_pollenRecordByLevelName objectForKey:levelName] != nil;
}

-(BOOL) hasPlayedLevel:(NSString *)levelName
{
	return [self pollenRecord:levelName] > 0;
}

-(BOOL) canPlayLevel:(NSString *)levelName
{
	if ([self hasCompletedLevelAtLeastOnce:levelName])
	{
		return true;
	}
	else
	{
		NSString *levelNameBefore = [[LevelOrganizer sharedOrganizer] levelNameBefore:levelName];
		return levelNameBefore == nil || [self hasCompletedLevelAtLeastOnce:levelNameBefore];
	}
}

-(BOOL) canPlayTheme:(NSString *)theme
{
	int requiredNumberOfFlowers = [[LevelOrganizer sharedOrganizer] requiredNumberOfFlowersForTheme:theme];
	return requiredNumberOfFlowers >= 0 && [self totalNumberOfFlowers] >= requiredNumberOfFlowers;
}

-(NSArray *) visibleThemes
{
	NSMutableArray *visibleThemes = [NSMutableArray array];
	for (NSString *theme in [[LevelOrganizer sharedOrganizer] themes])
	{
		BOOL includeTheme;
		if ([[LevelOrganizer sharedOrganizer] isThemeHidden:theme])
		{
			includeTheme = [self canPlayTheme:theme];
		}
		else
		{
			includeTheme = TRUE;
		}
		if (includeTheme)
		{
			[visibleThemes addObject:theme];
		}
	}
	return visibleThemes;
}

-(void) markTutorialIdAsSeen:(NSString *)tutorialId
{
	[_seenTutorialIds addObject:tutorialId];
}

-(void) markTutorialIdAsSeenAndSave:(NSString *)tutorialId
{
	[self markTutorialIdAsSeen:tutorialId];
	[self save];
}

-(BOOL) hasSeenTutorialId:(NSString *)tutorialId
{
	return [_seenTutorialIds containsObject:tutorialId];
}

-(NSString *) defaultTheme
{
	if (_defaultTheme != nil)
	{
		return _defaultTheme;
	}
	else
	{
		return [[[LevelOrganizer sharedOrganizer] themes] objectAtIndex:0];
	}
}

@end
