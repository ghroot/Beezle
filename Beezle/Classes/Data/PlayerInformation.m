//
//  PlayerInformation.m
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"
#import "DisposableComponent.h"
#import "PollenComponent.h"

@implementation PlayerInformation

@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;

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
}

-(void) storeForThisLevel
{
	[_consumedDisposableIds addObjectsFromArray:_consumedDisposableIdsThisLevel];
	_numberOfCollectedPollen += _numberOfCollectedPollenThisLevel;
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
	
	PollenComponent *pollenComponent = [PollenComponent getFrom:entity];
	_numberOfCollectedPollenThisLevel += [pollenComponent pollenCount];
}

@end
