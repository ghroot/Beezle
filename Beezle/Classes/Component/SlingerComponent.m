//
//  SlingerComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerComponent.h"

static const int AIM_POLLEN_INTERVAL = 16;

@implementation SlingerComponent

@synthesize state = _state;
@synthesize queuedBeeTypes = _queuedBeeTypes;
@synthesize loadedBeeType = _loadedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_name = @"slinger";
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

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSMutableArray *queuedBeeTypesAsStrings = [NSMutableArray array];
	for (BeeType *queuedBeeType in _queuedBeeTypes)
	{
		[queuedBeeTypesAsStrings addObject:[queuedBeeType name]];
	}
	[dict setObject:queuedBeeTypesAsStrings forKey:@"queuedBeeTypes"];
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"queuedBeeTypes"])
	{
		NSArray *queuedBeeTypesAsStrings = [dict objectForKey:@"queuedBeeTypes"];
		for (NSString *queuedBeeTypeAsString in queuedBeeTypesAsStrings)
		{
			BeeType *queuedBeeType = [BeeType enumFromName:queuedBeeTypeAsString];
			[self pushBeeType:queuedBeeType];
		}
	}
}

-(void) pushBeeType:(BeeType *)beeType
{
	[_queuedBeeTypes addObject:beeType];
}

-(BeeType *) popNextBeeType
{
	BeeType *nextBeeType = [_queuedBeeTypes objectAtIndex:0];
	[nextBeeType retain];
	[_queuedBeeTypes removeObjectAtIndex:0];
	
	return [nextBeeType autorelease];
}

-(BOOL) hasMoreBees
{
	return [self numberOfBeesInQueue] > 0;
}

-(int) numberOfBeesInQueue
{
	return [_queuedBeeTypes count];
}

-(void) clearBeeTypes
{
	[_queuedBeeTypes removeAllObjects];
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

-(void) revertLoadedBee
{
    [_queuedBeeTypes insertObject:_loadedBeeType atIndex:0];
    [self clearLoadedBee];
}

-(BOOL) hasLoadedBee
{
	return _loadedBeeType != nil;
}

-(void) resetAimPollenCountdown
{
	_aimPollenCountdown = AIM_POLLEN_INTERVAL;
}

-(void) decreaseAimPollenCountdown
{
	_aimPollenCountdown--;
}

-(BOOL) hasAimPollenCountdownReachedZero
{
	return _aimPollenCountdown == 0;
}

@end
