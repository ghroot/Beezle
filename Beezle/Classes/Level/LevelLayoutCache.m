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
	NSMutableArray *layouts = [_levelLayoutsByName objectForKey:[levelLayout levelName]];
	if (layouts == nil)
	{
		layouts = [NSMutableArray array];
		[_levelLayoutsByName setObject:layouts forKey:[levelLayout levelName]];
	}
	[layouts addObject:levelLayout];
}

-(void) addLevelLayoutWithDictionary:(NSDictionary *)dict
{
	[self addLevelLayout:[LevelLayout layoutWithContentsOfDictionary:dict]];
}

-(void) addLevelLayoutWithWorld:(World *)world levelName:(NSString *)levelName version:(int)version
{
	[self addLevelLayout:[LevelLayout layoutWithContentsOfWorld:world levelName:levelName version:version]];
}

-(NSArray *) allLevelLayoutsByName:(NSString *)levelName
{
	return [_levelLayoutsByName objectForKey:levelName];
}

-(LevelLayout *) latestLevelLayoutByName:(NSString *)levelName
{
	NSMutableArray *layouts = [_levelLayoutsByName objectForKey:levelName];
	if (layouts)
	{
		return [layouts lastObject];
	}
	else
	{
		return nil;
	}
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
