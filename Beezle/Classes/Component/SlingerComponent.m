//
//  SlingerComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerComponent.h"

@implementation SlingerComponent

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

-(void) pushBeeType:(BeeType)beeType
{
	NSNumber *beeTypeNumber = [NSNumber numberWithInt:beeType];
	[_queuedBeeTypes addObject:beeTypeNumber];
}

-(BeeType) popNextBeeType
{
	NSNumber *nextBeeTypeNumber = [[_queuedBeeTypes objectAtIndex:0] retain];
	[_queuedBeeTypes removeObjectAtIndex:0];
	BeeType nextBeeType = [nextBeeTypeNumber intValue];
	[nextBeeTypeNumber release];
	return nextBeeType;
}

-(BOOL) hasMoreBees
{
	return [_queuedBeeTypes count] > 0;
}

@end
