//
//  MovementComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Makes the entity move between checkpoints.
 */
@interface MovementComponent : Component
{
    // Type
    BOOL _alwaysFaceForward;
    
    // Instance
	NSArray *_positions;
	
    // Transient
	BOOL _isMovingPaused;
	int _currentPositionIndex;
	BOOL _isMovingForwardInPositionList;
	CGPoint _startPosition;
	BOOL _isMovingTowardsStartPosition;
}

@property (nonatomic) BOOL alwaysFaceForward;
@property (nonatomic, retain) NSArray *positions;
@property (nonatomic) BOOL isMovingPaused;
@property (nonatomic) int currentPositionIndex;
@property (nonatomic) BOOL isMovingForwardInPositionList;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) BOOL isMovingTowardsStartPosition;

@end
