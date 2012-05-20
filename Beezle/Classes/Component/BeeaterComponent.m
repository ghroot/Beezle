//
//  BeeaterComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeaterComponent.h"
#import "NotificationTypes.h"
#import "StringList.h"

@implementation BeeaterComponent

@synthesize showBeeAnimationNameFormat = _showBeeAnimationNameFormat;
@synthesize showBeeBetweenAnimationNames = _showBeeBetweenAnimationNames;

-(id) init
{
	if (self = [super init])
	{
		_name = @"beeater";
		_showBeeBetweenAnimationNames = [StringList new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _showBeeAnimationNameFormat = [[typeComponentDict objectForKey:@"showBeeAnimationFormat"] copy];
		[_showBeeBetweenAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"showBeeBetweenAnimation"];
	}
	return self;
}

-(void) dealloc
{
    [_showBeeAnimationNameFormat release];
    [_showBeeBetweenAnimationNames release];
    
    [super dealloc];
}

@end
