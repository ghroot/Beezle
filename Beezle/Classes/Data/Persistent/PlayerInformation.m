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

@interface PlayerInformation()

-(void) cloudDataDidChange:(NSNotification *)notification;
-(void) load;
-(NSDictionary *) getInformationAsDictionary;
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDataDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
	[[NSUbiquitousKeyValueStore defaultStore] synchronize];
#endif
}

-(void) cloudDataDidChange:(NSNotification *)notification
{
	NSDictionary *cloudDict = [notification userInfo];

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
	_isSoundMuted = [[cloudDict objectForKey:@"isSoundMuted"] boolValue];
	_usingAdvancedControlScheme = [[cloudDict objectForKey:@"usingAdvancedControlScheme"] boolValue];
}

-(void) save
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *fileName = @"Player-Information.plist";
//	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//	BOOL success = [[self getInformationAsDictionary] writeToFile:filePath atomically:TRUE];
//	if (!success)
//	{
//		NSLog(@"Player information failed to save...");
//	}

	NSDictionary *dict = [self getInformationAsDictionary];

	[[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"playerInformation"];
	[[NSUserDefaults standardUserDefaults] synchronize];

#ifdef ICLOUD
	[[NSUbiquitousKeyValueStore defaultStore] setObject:dict forKey:@"playerInformation"];
#endif
}

-(void) load
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *fileName = @"Player-Information.plist";
//	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];

	NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"playerInformation"];

	if (dict != nil)
	{
		[_pollenRecordByLevelName addEntriesFromDictionary:[dict objectForKey:@"pollenRecordByLevelName"]];
		[_seenTutorialIds addObjectsFromArray:[dict objectForKey:@"seenTutorialIds"]];
		_isSoundMuted = [[dict objectForKey:@"isSoundMuted"] boolValue];
		_usingAdvancedControlScheme = [[dict objectForKey:@"usingAdvancedControlScheme"] boolValue];
	}
}

-(void) reset
{
	[_pollenRecordByLevelName removeAllObjects];
	[_seenTutorialIds removeAllObjects];
	_isSoundMuted = FALSE;
	_usingAdvancedControlScheme = FALSE;
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *fileName = @"Player-Information.plist";
//	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"playerInformation"];
	[[NSUserDefaults standardUserDefaults] synchronize];

#ifdef ICLOUD
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:@"playerInformation"];
#endif
}

-(NSDictionary *) getInformationAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSDictionary dictionaryWithDictionary:_pollenRecordByLevelName] forKey:@"pollenRecordByLevelName"];
	[dict setObject:[_seenTutorialIds allObjects] forKey:@"seenTutorialIds"];
	[dict setObject:[NSNumber numberWithBool:_isSoundMuted] forKey:@"isSoundMuted"];
	[dict setObject:[NSNumber numberWithBool:_usingAdvancedControlScheme] forKey:@"usingAdvancedControlScheme"];
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
