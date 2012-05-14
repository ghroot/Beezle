//
//  WobbleComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WobbleComponent.h"
#import "StringList.h"

@implementation WobbleComponent

-(id) init
{
	if (self = [super init])
	{
		_name = @"wobble";
		_wobbleAnimationNames = [StringList new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		[_wobbleAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"wobbleAnimation"];
	}
	return self;
}

-(void) dealloc
{
	[_wobbleAnimationNames release];
	
	[super dealloc];
}

-(NSString *) randomWobbleAnimationName
{
	return [_wobbleAnimationNames randomString];
}

@end
