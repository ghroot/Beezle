//
//  GateComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GateComponent.h"

@implementation GateComponent

@synthesize hiddenLevelName = _hiddenLevelName;
@synthesize isOpened = _isOpened;

-(id) init
{
	if (self = [super init])
	{
		_name = @"gate";
	}
	return self;
}

-(void) dealloc
{
	[_hiddenLevelName release];
	
	[super dealloc];
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"hiddenLevel"])
	{
		_hiddenLevelName = [[dict objectForKey:@"hiddenLevel"] copy];
	}
}

@end
