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
@synthesize loadedBeeType = _loadedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_queuedBeeTypes = [[NSMutableArray alloc] init];
		_loadedBeeType = nil;
	}
	return self;
}

-(void) dealloc
{
	[_queuedBeeTypes release];
	
	if ([self hasLoadedBee])
	{
		[self clearLoadedBee];
	}
	
	[super dealloc];
}

-(void) pushBeeType:(BeeTypes *)beeType
{
	[_queuedBeeTypes addObject:beeType];
}

-(BeeTypes *) popNextBeeType
{
	BeeTypes *nextBeeType = [_queuedBeeTypes objectAtIndex:0];
	[nextBeeType retain];
	[_queuedBeeTypes removeObjectAtIndex:0];
	return [nextBeeType autorelease];
}

-(BOOL) hasMoreBees
{
	return [_queuedBeeTypes count] > 0;
}

-(void) loadNextBee
{
	_loadedBeeType = [[self popNextBeeType] retain];
}

-(void) clearLoadedBee
{
	[_loadedBeeType release];
	_loadedBeeType = nil;
}

-(BOOL) hasLoadedBee
{
	return _loadedBeeType != nil;
}

@end
