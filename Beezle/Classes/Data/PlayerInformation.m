//
//  PlayerInformation.m
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"

@implementation PlayerInformation

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

-(void) resetConsumedDisposableIdsThisLevel
{
	[_consumedDisposableIdsThisLevel removeAllObjects];
}

-(void) storeConsumedDisposableIdsFromThisLevel
{
	[_consumedDisposableIds addObjectsFromArray:_consumedDisposableIdsThisLevel];
	[self resetConsumedDisposableIdsThisLevel];
}

-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId
{
	[_consumedDisposableIdsThisLevel addObject:disposableId];
}

-(BOOL) hasConsumedDisposableId:(NSString *)disposableId
{
	return [_consumedDisposableIds containsObject:disposableId];
}

@end
