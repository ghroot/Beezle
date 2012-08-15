//
//  WoodComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoodComponent.h"
#import "StringCollection.h"

@implementation WoodComponent

-(id) init
{
	if (self = [super init])
	{
		_sawedAnimationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		[_sawedAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"sawedAnimation"];
	}
	return self;
}

-(void) dealloc
{
	[_sawedAnimationNames release];

	[super dealloc];
}

-(NSString *) randomSawedAnimationName
{
	return [_sawedAnimationNames randomString];
}

@end
