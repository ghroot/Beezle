//
//  EntityDescriptionSerializer.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescriptionSerializer.h"
#import "EntityDescription.h"

@implementation EntityDescriptionSerializer

+(EntityDescriptionSerializer *) sharedSerializer
{
    static EntityDescriptionSerializer *serializer = 0;
    if (!serializer)
    {
        serializer = [[self alloc] init];
    }
    return serializer;
}

-(EntityDescription *) entityDescriptionFromDictionary:(NSDictionary *)dict
{
	if (dict != nil)
	{
		EntityDescription *entityDescription = [[[EntityDescription alloc] init] autorelease];
		
		[entityDescription setType:[dict objectForKey:@"type"]];
		[entityDescription setGroups:[dict objectForKey:@"groups"]];
		[entityDescription setTags:[dict objectForKey:@"tags"]];
		[entityDescription setLabels:[dict objectForKey:@"labels"]];
		[entityDescription setTypeComponentsDict:[dict objectForKey:@"components"]];
		
		return entityDescription;
	}
	else
	{
		return nil;
	}
}

@end
