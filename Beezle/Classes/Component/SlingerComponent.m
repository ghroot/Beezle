//
//  SlingerComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerComponent.h"

@implementation SlingerComponent

@synthesize queuedBeeTypes = _queuedBeeTypes;

-(id) init
{
	if (self = [super init])
	{
		_queuedBeeTypes = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_queuedBeeTypes release];
	
	[super dealloc];
}

-(void) pushBeeType:(BeeTypes *)beeType
{
	[_queuedBeeTypes addObject:beeType];
}

-(BeeTypes *) popNextBeeType
{
	BeeTypes *nextBeeType = [_queuedBeeTypes objectAtIndex:0];
	[_queuedBeeTypes removeObjectAtIndex:0];
	return nextBeeType;
}

-(BOOL) hasMoreBees
{
	return [_queuedBeeTypes count] > 0;
}

@end
