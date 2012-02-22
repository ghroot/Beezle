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
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_pollenCollectionRecordByLevelName release];
	
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
	}
}

-(void) reset
{
	[_pollenCollectionRecordByLevelName removeAllObjects];
	_numberOfCollectedPollenThisLevel = 0;
	
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
	return dict;
}

-(void) resetForThisLevel
{
	_numberOfCollectedPollenThisLevel = 0;
}

-(void) storeForThisLevel:(NSString *)levelName
{
	[_pollenCollectionRecordByLevelName setObject:[NSNumber numberWithInt:_numberOfCollectedPollenThisLevel] forKey:levelName];
	[self resetForThisLevel];
}

-(void) consumedEntity:(Entity *)entity
{	
	if ([entity hasComponent:[PollenComponent class]])
	{
		_numberOfCollectedPollenThisLevel += [[PollenComponent getFrom:entity] pollenCount];
	}
}

-(BOOL) isCurrentLevelRecord:(NSString *)levelName
{
	if ([_pollenCollectionRecordByLevelName objectForKey:levelName] != nil)
	{
		int recordForLevel = [[_pollenCollectionRecordByLevelName objectForKey:levelName] intValue];
		return _numberOfCollectedPollenThisLevel > recordForLevel;
	}
	else
	{
		return _numberOfCollectedPollenThisLevel > 0;
	}
}

-(int) numberOfCollectedPollen
{
	int total = 0;
	for (NSNumber *pollenCollectionRecord in [_pollenCollectionRecordByLevelName allValues])
	{
		total += [pollenCollectionRecord intValue];
	}
	return total;
}


@end
