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

@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;
@synthesize numberOfCurrentKeys = _numberOfCurrentKeys;

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
		_consumedDisposableIds = [[NSMutableArray alloc] init];
		_consumedDisposableIdsThisLevel = [[NSMutableArray alloc] init];
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_consumedDisposableIds release];
	[_consumedDisposableIdsThisLevel release];
	
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
		_numberOfCollectedPollen = [[dict objectForKey:@"numberOfCollectedPollen"] intValue];
		_numberOfCurrentKeys = [[dict objectForKey:@"numberOfCurrentKeys"] intValue];
		[_consumedDisposableIds addObjectsFromArray:[dict objectForKey:@"consumedDisposableIds"]];
	}
}

-(void) reset
{
	_numberOfCollectedPollen = 0;
	_numberOfCurrentKeys = 0;
	[_consumedDisposableIds removeAllObjects];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Player-Information.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

-(NSDictionary *) getInformationAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithInt:_numberOfCollectedPollen] forKey:@"numberOfCollectedPollen"];
	[dict setObject:[NSNumber numberWithInt:_numberOfCurrentKeys] forKey:@"numberOfCurrentKeys"];
	[dict setObject:[NSArray arrayWithArray:_consumedDisposableIds] forKey:@"consumedDisposableIds"];
	return dict;
}

-(void) resetForThisLevel
{
	[_consumedDisposableIdsThisLevel removeAllObjects];
	_numberOfCollectedPollenThisLevel = 0;
	_numberOfCollectedKeysThisLevel = 0;
}

-(void) storeForThisLevel
{
	[_consumedDisposableIds addObjectsFromArray:_consumedDisposableIdsThisLevel];
	_numberOfCollectedPollen += _numberOfCollectedPollenThisLevel;
	_numberOfCurrentKeys += _numberOfCollectedKeysThisLevel;
	[self resetForThisLevel];
}

-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId
{
	[_consumedDisposableIdsThisLevel addObject:disposableId];
}

-(BOOL) hasConsumedDisposableId:(NSString *)disposableId
{
	return [_consumedDisposableIds containsObject:disposableId];
}

-(void) consumedEntity:(Entity *)entity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
	[self addConsumedDisposableIdThisLevel:[disposableComponent disposableId]];
	
	if ([entity hasComponent:[PollenComponent class]])
	{
		_numberOfCollectedPollenThisLevel += [[PollenComponent getFrom:entity] pollenCount];
	}
	if ([entity hasComponent:[KeyComponent class]])
	{
		_numberOfCollectedKeysThisLevel++;
	}
}

-(void) decrementNumberOfCurrentKeys
{
	_numberOfCurrentKeys--;
}


@end
