//
//  EntityDescriptionLoader.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescriptionLoader.h"
#import "EntityDescription.h"
#import "EntityDescriptionSerializer.h"

@implementation EntityDescriptionLoader

+(EntityDescriptionLoader *) sharedLoader
{
    static EntityDescriptionLoader *loader = 0;
    if (!loader)
    {
        loader = [[self alloc] init];
    }
    return loader;
}

-(EntityDescription *) loadEntityDescription:(NSString *)type
{
	NSString *fileName = [NSString stringWithFormat:@"%@.plist", type];
	NSString *filePath = [CCFileUtils fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	return [[EntityDescriptionSerializer sharedSerializer] entityDescriptionFromDictionary:dict];
}

@end
