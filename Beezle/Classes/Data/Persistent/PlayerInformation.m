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

-(void) load;
-(NSDictionary *) getInformationAsDictionary;
-(BOOL) hasCompletedLevelAtLeastOnce:(NSString *)levelName;

@end

@implementation PlayerInformation

@synthesize isSoundMuted = _isSoundMuted;

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
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_pollenRecordByLevelName release];
	[_seenTutorialIds release];
	
	[super dealloc];
}

-(void) save
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Player-Information.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	BOOL success = [[self getInformationAsDictionary] writeToFile:filePath atomically:TRUE];
	if (!success)
	{
		NSLog(@"Player information failed to save...");
	}
}

-(void) load
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Player-Information.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		[_pollenRecordByLevelName addEntriesFromDictionary:[dict objectForKey:@"pollenRecordByLevelName"]];
		[_seenTutorialIds addObjectsFromArray:[dict objectForKey:@"seenTutorialIds"]];
		_isSoundMuted = [[dict objectForKey:@"isSoundMuted"] boolValue];
	}
}

-(void) reset
{
	[_pollenRecordByLevelName removeAllObjects];
	[_seenTutorialIds removeAllObjects];
	_isSoundMuted = FALSE;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Player-Information.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

-(NSDictionary *) getInformationAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSDictionary dictionaryWithDictionary:_pollenRecordByLevelName] forKey:@"pollenRecordByLevelName"];
	[dict setObject:[_seenTutorialIds allObjects] forKey:@"seenTutorialIds"];
	[dict setObject:[NSNumber numberWithBool:_isSoundMuted] forKey:@"isSoundMuted"];
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
#ifdef DEBUG
	return TRUE;
#else
	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	int themeIndex = [themes indexOfObject:theme];
	if (themeIndex == 0)
	{
		return TRUE;
	}
	else
	{
		NSString *previousTheme = [themes objectAtIndex:themeIndex - 1];
		NSString *lastLevelNameInPreviousTheme = [[[LevelOrganizer sharedOrganizer] levelNamesInTheme:previousTheme] lastObject];
		return [self hasPlayedLevel:lastLevelNameInPreviousTheme];
	}
#endif
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
