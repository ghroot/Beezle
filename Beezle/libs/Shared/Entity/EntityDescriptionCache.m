//
//  EntityDescriptionCache.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescriptionCache.h"

@implementation EntityDescriptionCache

+(EntityDescriptionCache *) sharedCache
{
    static EntityDescriptionCache *cache = 0;
    if (!cache)
    {
        cache = [[self alloc] init];
    }
    return cache;
}

-(id) init
{
	if (self = [super init])
	{
		_entityDescriptionsByType = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_entityDescriptionsByType release];
	
	[super dealloc];
}

-(void) addEntityDescription:(EntityDescription *)entityDescription
{
	[_entityDescriptionsByType setObject:entityDescription forKey:[entityDescription type]];
}

-(EntityDescription *) entityDescriptionByType:(NSString *)type
{
	return [_entityDescriptionsByType objectForKey:type];
}

-(void) purgeCachedData
{
	[_entityDescriptionsByType removeAllObjects];
}

@end
