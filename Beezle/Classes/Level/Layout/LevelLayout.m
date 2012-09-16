//
//  LevelLayout.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayout.h"
#import "LevelLayoutEntry.h"
#import "LevelSerializer.h"

@implementation LevelLayout

@synthesize levelName = _levelName;
@synthesize format = _format;
@synthesize version = _version;
@synthesize pollenForTwoFlowers = _pollenForTwoFlowers;
@synthesize pollenForThreeFlowers = _pollenForThreeFlowers;
@synthesize hasWater = _hasWater;
@synthesize entries = _entries;
@synthesize isEdited = _isEdited;

+(LevelLayout *) layout
{
	return [[[self alloc] init] autorelease];
}

+(LevelLayout *) layoutWithContentsOfDictionary:(NSDictionary *)dict
{
	return [[LevelSerializer sharedSerializer] layoutFromDictionary:dict];
}

+(LevelLayout *) layoutWithContentsOfFile:(NSString *)filePath
{
	return [[LevelSerializer sharedSerializer] layoutFromDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
}

+(LevelLayout *) layoutWithContentsOfWorld:(World *)world levelName:(NSString *)levelName version:(int)version
{
	return [[LevelSerializer sharedSerializer] layoutFromWorld:world levelName:levelName version:version];
}

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
    {
		_levelName = [levelName retain];
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) init
{
    return [self initWithLevelName:nil];
}

-(void) dealloc
{
	[_levelName release];
    [_entries release];
    
    [super dealloc];
}

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry
{
    [_entries addObject:entry];
}

-(NSDictionary *) layoutAsDictionary
{
	return [[LevelSerializer sharedSerializer] dictionaryFromLayout:self];
}

-(BOOL) hasEntityWithType:(NSString *)entityType
{
	for (LevelLayoutEntry *entry in _entries)
	{
		if ([[entry type] isEqualToString:entityType])
		{
			return TRUE;
		}
	}
	return FALSE;
}

@end
