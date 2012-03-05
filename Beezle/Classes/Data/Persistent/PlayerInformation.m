//
//  PlayerInformation.m
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"
#import "DisposableComponent.h"
#import "KeyComponent.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "PollenComponent.h"

@interface PlayerInformation()

-(void) load;
-(NSDictionary *) getInformationAsDictionary;
-(BOOL) hasCompletedLevelAtLeastOnce:(NSString *)levelName;

@end

@implementation PlayerInformation

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
		_levelNamesWhereKeysWereCollected = [NSMutableArray new];
		_levelNamesWhereKeysWereUsed = [NSMutableArray new];
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_pollenRecordByLevelName release];
	[_levelNamesWhereKeysWereCollected release];
	[_levelNamesWhereKeysWereUsed release];
	
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
		[_levelNamesWhereKeysWereCollected addObjectsFromArray:[dict objectForKey:@"levelNamesWhereKeysWereCollected"]];
		[_levelNamesWhereKeysWereUsed addObjectsFromArray:[dict objectForKey:@"levelNamesWhereKeysWereUsed"]];
	}
}

-(void) reset
{
	[_pollenRecordByLevelName removeAllObjects];
	[_levelNamesWhereKeysWereCollected removeAllObjects];
	[_levelNamesWhereKeysWereUsed removeAllObjects];
	
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
	[dict setObject:[NSArray arrayWithArray:_levelNamesWhereKeysWereCollected] forKey:@"levelNamesWhereKeysWereCollected"];
	[dict setObject:[NSArray arrayWithArray:_levelNamesWhereKeysWereUsed] forKey:@"levelNamesWhereKeysWereUsed"];
	return dict;
}

-(void) store:(LevelSession *)levelSession
{
	if ([self isPollenRecord:levelSession])
	{
		[_pollenRecordByLevelName setObject:[NSNumber numberWithInt:[levelSession totalNumberOfPollen]] forKey:[levelSession levelName]];
	}
	if ([levelSession didCollectKey] &&
		![_levelNamesWhereKeysWereCollected containsObject:[levelSession levelName]])
	{
		[_levelNamesWhereKeysWereCollected addObject:[levelSession levelName]];
	}
	if ([levelSession didUseKey] &&
		![_levelNamesWhereKeysWereUsed containsObject:[levelSession levelName]])
	{
		[_levelNamesWhereKeysWereUsed addObject:[levelSession levelName]];
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

-(BOOL) hasCollectedKeyInLevel:(NSString *)levelName
{
	return [_levelNamesWhereKeysWereCollected containsObject:levelName];
}

-(BOOL) hasUsedKeyInLevel:(NSString *)levelName
{
	return [_levelNamesWhereKeysWereUsed containsObject:levelName];
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

-(int) totalNumberOfKeys
{
	return [_levelNamesWhereKeysWereCollected count] - [_levelNamesWhereKeysWereUsed count];
}

-(BOOL) hasCompletedLevelAtLeastOnce:(NSString *)levelName
{
    return [_pollenRecordByLevelName objectForKey:levelName] != nil;
}

-(BOOL) canPlayLevel:(NSString *)levelName
{
	NSString *levelNameBefore = [[LevelOrganizer sharedOrganizer] levelNameBefore:levelName];
	return levelNameBefore == nil || [self hasCompletedLevelAtLeastOnce:levelNameBefore];
}

@end
