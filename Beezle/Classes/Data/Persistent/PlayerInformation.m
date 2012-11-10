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
#ifdef ICLOUD
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#endif

	[_pollenRecordByLevelName release];
	[_seenTutorialIds release];
	
	[super dealloc];
}

-(void) initialise
{
	[self load];

#ifdef ICLOUD
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

#ifdef ICLOUD
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
	}
}

-(void) reset
{
	[_pollenRecordByLevelName removeAllObjects];
	[_seenTutorialIds removeAllObjects];
	_isSoundMuted = FALSE;
	_usingAdvancedControlScheme = FALSE;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:SETTINGS_KEY];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:PROGRESS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];

#ifdef ICLOUD
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
	return dict;
}

-(void) store:(LevelSession *)levelSession
{
	if ([self isPollenRecord:levelSession])
	{
		[_pollenRecordByLevelName setObject:[NSNumber numberWithInt:[levelSession totalNumberOfPollen]] forKey:[levelSession levelName]];
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
	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	int themeIndex = [themes indexOfObject:theme];
	if (themeIndex == 0)
	{
		return TRUE;
	}
	else
	{
		NSString *previousTheme = [themes objectAtIndex:themeIndex - 1];
		return [self flowerRecordForTheme:previousTheme] >= NUMBER_OF_REQUIRED_FLOWERS_TO_UNLOCK_NEXT_THEME;
	}
}

-(NSString *) latestPlayableTheme
{
	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	for (int i = [themes count] - 1; i >= 0; i--)
	{
		NSString *theme = [themes objectAtIndex:i];
		if ([self canPlayTheme:theme])
		{
			return theme;
		}
	}
	return [themes objectAtIndex:0];
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

@end
