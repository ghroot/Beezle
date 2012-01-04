//
//  LevelOrganizer.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelOrganizer.h"

@implementation LevelOrganizer

+(LevelOrganizer *) sharedOrganizer
{
    static LevelOrganizer *organizer = 0;
    if (!organizer)
    {
        organizer = [[self alloc] init];
    }
    return organizer;
}

-(id) init
{
	if (self = [super init])
	{
		_levelNamesByTheme = [[NSMutableDictionary alloc] init];
		
		[self addLevelNamesWithFile:@"Levels.plist"];
	}
	return self;
}

-(void) dealloc
{
	[_levelNamesByTheme release];
	
	[super dealloc];
}

-(void) addLevelNamesWithDictionary:(NSDictionary *)dict
{
	NSDictionary *themes = [dict objectForKey:@"themes"];
	for (NSString *theme in [themes allKeys])
	{
		NSArray *levels = [themes objectForKey:theme];
		[_levelNamesByTheme setObject:levels forKey:theme];
	}
}

-(void) addLevelNamesWithFile:(NSString *)fileName
{
    NSString *path = [CCFileUtils fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	[self addLevelNamesWithDictionary:dict];
}

-(NSArray *) themes
{
	return [_levelNamesByTheme allKeys];
}

-(NSArray *) levelNamesForTheme:(NSString *)theme
{
	return [_levelNamesByTheme objectForKey:theme];
}

@end
