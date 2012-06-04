//
//  EntityDescriptionCache.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescriptionCache.h"
#import "EntityDescriptionLoader.h"

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

-(EntityDescription *) entityDescriptionByType:(NSString *)type
{
	EntityDescription *entityDescription = [_entityDescriptionsByType objectForKey:type];
	if (entityDescription == nil)
	{
		entityDescription = [[EntityDescriptionLoader sharedLoader] loadEntityDescription:type];
		if (entityDescription != nil)
		{
			[_entityDescriptionsByType setObject:entityDescription forKey:[entityDescription type]];
		}
	}
	return entityDescription;
}

-(void) purgeCachedData
{
	[_entityDescriptionsByType removeAllObjects];
}

@end
