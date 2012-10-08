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

@synthesize queuedBeeTypes = _queuedBeeTypes;
@synthesize state = _state;
@synthesize loadedBeeType = _loadedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_queuedBeeTypes = [[NSMutableArray alloc] init];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Instance
		NSArray *queuedBeeTypesAsStrings = [instanceComponentDict objectForKey:@"queuedBeeTypes"];
		for (NSString *queuedBeeTypeAsString in queuedBeeTypesAsStrings)
		{
			BeeType *queuedBeeType = [BeeType enumFromName:queuedBeeTypeAsString];
			[self pushBeeType:queuedBeeType];
		}
	}
	return self;
}

-(void) dealloc
{
	[_queuedBeeTypes release];

	[super dealloc];
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	NSMutableArray *queuedBeeTypesAsStrings = [NSMutableArray array];
	for (BeeType *queuedBeeType in _queuedBeeTypes)
	{
		[queuedBeeTypesAsStrings addObject:[queuedBeeType name]];
	}
	[instanceComponentDict setObject:queuedBeeTypesAsStrings forKey:@"queuedBeeTypes"];
	return instanceComponentDict;
}

-(void) pushBeeType:(BeeType *)beeType
{
	[_queuedBeeTypes addObject:beeType];
}

-(void) insertBeeTypeAtStart:(BeeType *)beeType
{
	[_queuedBeeTypes insertObject:beeType atIndex:0];
}

-(BeeType *) popNextBeeType
{
	BeeType *nextBeeType = [_queuedBeeTypes objectAtIndex:0];
	[_queuedBeeTypes removeObjectAtIndex:0];
	return nextBeeType;
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
	_loadedBeeType = [self popNextBeeType];
}

-(void) clearLoadedBee
{
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
