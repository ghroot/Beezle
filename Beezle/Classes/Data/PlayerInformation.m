//
//  PlayerInformation.m
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"
#import "DisposableComponent.h"
#import "KeyComponent.h"
#import "PollenComponent.h"

@implementation PlayerInformation

@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;
@synthesize numberOfCurrentKeys = _numberOfCurrentKeys;

+(PlayerInformation *) sharedInformation
{
    static PlayerInformation *information = 0;
    if (!information)
    {
        information = [[self alloc] init];
    }
    return information;
}

-(id) init
{
	if (self = [super init])
	{
		_consumedDisposableIds = [[NSMutableArray alloc] init];
		_consumedDisposableIdsThisLevel = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_consumedDisposableIds release];
	[_consumedDisposableIdsThisLevel release];
	
	[super dealloc];
}

-(void) resetForThisLevel
{
	[_consumedDisposableIdsThisLevel removeAllObjects];
	_numberOfCollectedPollenThisLevel = 0;
	_numberOfCollectedKeysThisLevel = 0;
}

-(void) storeForThisLevel
{
	[_consumedDisposableIds addObjectsFromArray:_consumedDisposableIdsThisLevel];
	_numberOfCollectedPollen += _numberOfCollectedPollenThisLevel;
	_numberOfCurrentKeys += _numberOfCollectedKeysThisLevel;
	[self resetForThisLevel];
}

-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId
{
	[_consumedDisposableIdsThisLevel addObject:disposableId];
}

-(BOOL) hasConsumedDisposableId:(NSString *)disposableId
{
	return [_consumedDisposableIds containsObject:disposableId];
}

-(void) consumedEntity:(Entity *)entity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
	[self addConsumedDisposableIdThisLevel:[disposableComponent disposableId]];
	
	if ([entity hasComponent:[PollenComponent class]])
	{
		_numberOfCollectedPollenThisLevel += [[PollenComponent getFrom:entity] pollenCount];
	}
	if ([entity hasComponent:[KeyComponent class]])
	{
		_numberOfCollectedKeysThisLevel++;
	}
}

-(void) decrementNumberOfCurrentKeys
{
	_numberOfCurrentKeys--;
}

@end
