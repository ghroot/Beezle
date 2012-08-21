//
//  FrozenComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapturedComponent.h"
#import "BeeType.h"
#import "StringCollection.h"

@implementation CapturedComponent

@synthesize defaultContainedBeeType = _defaultContainedBeeType;
@synthesize containedBeeTypes = _containedBeeTypes;
@synthesize destroyedByBeeType = _destroyedByBeeType;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		StringCollection *defaultContainedBeeTypesAsStrings = [StringCollection collectionFromDictionary:typeComponentDict baseName:@"defaultContainedBeeType"];
		[_containedBeeTypes removeAllObjects];
		for (NSString *defaultContainedBeeTypeAsString in [defaultContainedBeeTypesAsStrings strings])
		{
			[_containedBeeTypes addObject:[BeeType enumFromName:defaultContainedBeeTypeAsString]];
		}
		
        // Instance
		if (instanceComponentDict != nil)
		{
			StringCollection *containedBeeTypesAsStrings = [StringCollection collectionFromDictionary:instanceComponentDict baseName:@"containedBeeType"];
			[_containedBeeTypes removeAllObjects];
			for (NSString *containedBeeTypeAsString in [containedBeeTypesAsStrings strings])
			{
				[_containedBeeTypes addObject:[BeeType enumFromName:containedBeeTypeAsString]];
			}
		}
	}
	return self;
}

-(id) init
{
	if (self = [super init])
	{
		_containedBeeTypes = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_containedBeeTypes release];

	[super dealloc];
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	NSMutableArray *containedBeeTypesAsStrings = [NSMutableArray array];
	for (BeeType *containedBeeType in _containedBeeTypes)
	{
		[containedBeeTypesAsStrings addObject:[containedBeeType name]];
	}
	[instanceComponentDict setObject:containedBeeTypesAsStrings forKey:@"containedBeeTypes"];
	return instanceComponentDict;
}

-(BeeType *) containedBeeType
{
	return [_containedBeeTypes objectAtIndex:0];
}

-(void) setContainedBeeType:(BeeType *)containedBeeType
{
	[_containedBeeTypes removeAllObjects];
	[_containedBeeTypes addObject:containedBeeType];
}

@end
