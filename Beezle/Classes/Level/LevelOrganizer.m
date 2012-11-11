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
		_levelNamesByTheme = [NSMutableDictionary new];
		_requiredNumberOfFlowersByTheme = [NSMutableDictionary new];

#ifdef LITE_VERSION
		[self addLevelNamesWithFile:@"Levels-Lite.plist"];
#else
		[self addLevelNamesWithFile:@"Levels.plist"];
#endif
	}
	return self;
}

-(void) dealloc
{
	[_levelNamesByTheme release];
	[_requiredNumberOfFlowersByTheme release];
	
	[super dealloc];
}

-(void) addLevelNamesWithDictionary:(NSDictionary *)dict
{
	NSDictionary *themes = [dict objectForKey:@"themes"];
	for (NSString *theme in [themes allKeys])
	{
		NSDictionary *themeDict = [themes objectForKey:theme];
		int requiredNumberOfFlowers = [[themeDict objectForKey:@"requiredNumberOfFlowers"] intValue];
		[_requiredNumberOfFlowersByTheme setObject:[NSNumber numberWithInt:requiredNumberOfFlowers] forKey:theme];
		NSArray *levels = [themeDict objectForKey:@"levels"];
		[_levelNamesByTheme setObject:levels forKey:theme];
	}
}

-(void) addLevelNamesWithFile:(NSString *)fileName
{
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	[self addLevelNamesWithDictionary:dict];
}

-(NSArray *) themes
{
	return [[_levelNamesByTheme allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

-(NSArray *) levelNamesInTheme:(NSString *)theme
{
	return [_levelNamesByTheme objectForKey:theme];
}

-(NSArray *) allLevelNames
{
	NSMutableArray *allLevelNames = [NSMutableArray array];
	for (NSString *theme in [self themes])
	{
		NSArray *levelNames = [self levelNamesInTheme:theme];
		[allLevelNames addObjectsFromArray:levelNames];
	}
	return allLevelNames;
}

-(NSString *) themeForLevel:(NSString *)levelName
{
    for (NSString *theme in [self themes])
    {
        NSArray *levelNamesInTheme = [self levelNamesInTheme:theme];
        if ([levelNamesInTheme containsObject:levelName])
        {
            return theme;
        }
    }
    return nil;
}

-(NSString *) themeAfter:(NSString *)theme
{
	NSArray *themes = [self themes];
	int themeIndex = [themes indexOfObject:theme];
	int themeIndexAfter = themeIndex + 1;
	if (themeIndexAfter >= [themes count])
	{
		return nil;
	}
	else
	{
		return [themes objectAtIndex:themeIndexAfter];
	}
}

-(NSString *) levelNameBefore:(NSString *)levelName
{
    NSArray *levelNamesInTheme = [self levelNamesInTheme:[self themeForLevel:levelName]];
    int index = [levelNamesInTheme indexOfObject:levelName];
    int indexBefore = index - 1;
    if (indexBefore < 0)
    {
        return nil;
    }
    else
    {
        return [levelNamesInTheme objectAtIndex:indexBefore];
    }
}

-(NSString *) levelNameAfter:(NSString *)levelName
{
    NSArray *levelNamesInTheme = [self levelNamesInTheme:[self themeForLevel:levelName]];
    int index = [levelNamesInTheme indexOfObject:levelName];
    int indexAfter = index + 1;
    if (indexAfter >= [levelNamesInTheme count])
    {
        return nil;
    }
    else
    {
        return [levelNamesInTheme objectAtIndex:indexAfter];
    }
}

-(BOOL) isLastLevelInGame:(NSString *)levelName
{
	NSString *theme = [self themeForLevel:levelName];
	NSString *lastTheme = [[self themes] lastObject];
	if ([theme isEqualToString:lastTheme])
	{
		NSString *lastLevelName = [[self levelNamesInTheme:theme] lastObject];
		return [levelName isEqualToString:lastLevelName];
	}
	else
	{
		return FALSE;
	}
}

-(int) requiredNumberOfFlowersForTheme:(NSString *)theme
{
	return [[_requiredNumberOfFlowersByTheme objectForKey:theme] intValue];
}

@end
