//
//  MovementComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface MovementComponent : Component
{
	NSArray *_positions;
	BOOL _alwaysFaceForward;
	int _currentPositionIndex;
	BOOL _isMovingForwardInPositionList;
	CGPoint _startPosition;
	BOOL _isMovingTowardsStartPosition;
}

@property (nonatomic, retain) NSArray *positions;
@property (nonatomic) BOOL alwaysFaceForward;
@property (nonatomic) int currentPositionIndex;
@property (nonatomic) BOOL isMovingForwardInPositionList;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) BOOL isMovingTowardsStartPosition;

@end
