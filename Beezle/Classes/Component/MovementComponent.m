//
//  MovementComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementComponent.h"

@implementation MovementComponent

@synthesize positions = _positions;
@synthesize currentPositionIndex = _currentPositionIndex;
@synthesize isMovingForwardInPositionList = _isMovingForwardInPositionList;
@synthesize startPosition = _startPosition;
@synthesize isMovingTowardsStartPosition = _isMovingTowardsStartPosition;

-(id) init
{
	if (self = [super init])
	{
		_positions = [[NSArray alloc] init];
		_isMovingForwardInPositionList = TRUE;
	}
	return self;
}

-(void) dealloc
{
	[_positions release];
	
	[super dealloc];
}

@end
