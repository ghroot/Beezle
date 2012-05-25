//
//  EntityDescription.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescription.h"

@implementation EntityDescription

@synthesize type = _type;
@synthesize groups = _groups;
@synthesize labels = _labels;
@synthesize tags = _tags;
@synthesize typeComponentsDict = _typeComponentsDict;

-(NSArray *) createComponents:(World *)world instanceComponentsDict:(NSDictionary *)instanceComponentsDict
{
	NSMutableArray *components = [NSMutableArray array];
	for (NSString *componentType in [_typeComponentsDict allKeys])
	{
        NSString *componentClassName = [[componentType capitalizedString] stringByAppendingString:@"Component"];
        Class componentClass = NSClassFromString(componentClassName);
        
		NSDictionary *typeComponentDict = [_typeComponentsDict objectForKey:componentType];
        NSDictionary *instanceComponentDict = [instanceComponentsDict objectForKey:componentType];
		
		if (componentClass != nil)
		{
            Component *component = [componentClass componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
			[components addObject:component];
		}
		else
		{
			NSLog(@"WARNING: Could not find class for component type: %@", componentType);
		}
	}
	return components;
}

@end
