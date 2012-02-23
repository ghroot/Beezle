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
#import "LevelSession.h"
#import "PollenComponent.h"

@interface PlayerInformation()

-(void) load;
-(NSDictionary *) getInformationAsDictionary;

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
		_pollenCollectionRecordByLevelName = [NSMutableDictionary new];
		_levelNamesWhereKeysWereCollected = [NSMutableArray new];
		_levelNamesWhereKeysWereUsed = [NSMutableArray new];
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_pollenCollectionRecordByLevelName release];
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
		[_pollenCollectionRecordByLevelName addEntriesFromDictionary:[dict objectForKey:@"pollenCollectionRecordByLevelName"]];
		[_levelNamesWhereKeysWereCollected addObjectsFromArray:[dict objectForKey:@"levelNamesWhereKeysWereCollected"]];
		[_levelNamesWhereKeysWereUsed addObjectsFromArray:[dict objectForKey:@"levelNamesWhereKeysWereUsed"]];
	}
}

-(void) reset
{
	[_pollenCollectionRecordByLevelName removeAllObjects];
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
	[dict setObject:[NSDictionary dictionaryWithDictionary:_pollenCollectionRecordByLevelName] forKey:@"pollenCollectionRecordByLevelName"];
	[dict setObject:[NSArray arrayWithArray:_levelNamesWhereKeysWereCollected] forKey:@"levelNamesWhereKeysWereCollected"];
	[dict setObject:[NSArray arrayWithArray:_levelNamesWhereKeysWereUsed] forKey:@"levelNamesWhereKeysWereUsed"];
	return dict;
}

-(void) store:(LevelSession *)levelSession
{
	if ([self isPollenRecord:levelSession])
	{
		[_pollenCollectionRecordByLevelName setObject:[NSNumber numberWithInt:[levelSession numberOfCollectedPollen]] forKey:[levelSession levelName]];
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

-(BOOL) isPollenRecord:(LevelSession *)levelSession
{
	if ([_pollenCollectionRecordByLevelName objectForKey:[levelSession levelName]] != nil)
	{
		int recordForLevel = [[_pollenCollectionRecordByLevelName objectForKey:[levelSession levelName]] intValue];
		return [levelSession numberOfCollectedPollen] > recordForLevel;
	}
	else
	{
		return TRUE;
	}
}

-(BOOL) hasUsedKeyInLevel:(NSString *)levelName
{
	return [_levelNamesWhereKeysWereUsed containsObject:levelName];
}

-(int) totalNumberOfCollectedPollen
{
	int total = 0;
	for (NSNumber *pollenCollectionRecord in [_pollenCollectionRecordByLevelName allValues])
	{
		total += [pollenCollectionRecord intValue];
	}
	return total;
}

-(int) totalNumberOfKeys
{
	return [_levelNamesWhereKeysWereCollected count] - [_levelNamesWhereKeysWereUsed count];
}


@end
