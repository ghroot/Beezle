//
//  LevelLayoutCache.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayoutCache.h"
#import "LevelLayout.h"

@implementation LevelLayoutCache

-(id) init
{
    if (self = [super init])
    {
        _levelLayoutsByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_levelLayoutsByName release];
    
    [super dealloc];
}

+(LevelLayoutCache *) sharedLevelLayoutCache
{
    static LevelLayoutCache *cache = 0;
    if (!cache)
    {
        cache = [[self alloc] init];
    }
    return cache;
}

-(void) addLevelLayout:(LevelLayout *)levelLayout
{
	[_levelLayoutsByName setObject:levelLayout forKey:[levelLayout levelName]];
}

-(LevelLayout *) levelLayoutByName:(NSString *)levelName
{
	return [_levelLayoutsByName objectForKey:levelName];
}

-(NSArray *) allLevelLayouts
{
	return [[_levelLayoutsByName allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
	{
		LevelLayout *levelLayout1 = (LevelLayout *)obj1;
		NSString *shortLevelName1 = [[levelLayout1 levelName] stringByReplacingOccurrencesOfString:@"Level-" withString:@""];
		NSString *levelNumber1AsString = [shortLevelName1 substringFromIndex:1];
		int levelNumber1 = [levelNumber1AsString intValue];
		
		LevelLayout *levelLayout2 = (LevelLayout *)obj2;
		NSString *shortLevelName2 = [[levelLayout2 levelName] stringByReplacingOccurrencesOfString:@"Level-" withString:@""];
		NSString *levelNumber2AsString = [shortLevelName2 substringFromIndex:1];
		int levelNumber2 = [levelNumber2AsString intValue];
		
		if (levelNumber1 < levelNumber2)
		{
			return NSOrderedAscending;
		}
		else if (levelNumber1 > levelNumber2)
		{
			return NSOrderedDescending;
		}
		else
		{
			return NSOrderedSame;
		}
	}];
}

-(void) purgeAllCachedLevelLayouts
{
	[_levelLayoutsByName removeAllObjects];
}

-(void) purgeCachedLevelLayout:(NSString *)levelName
{
	[_levelLayoutsByName removeObjectForKey:levelName];
}

@end
