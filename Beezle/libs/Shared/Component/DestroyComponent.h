//
//  DestroyComponent.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface DestroyComponent : Component
{
	// Type
	float _maxVelocity;
	float _minDuration;

	// Transient
	float _currentDuration;
}

@property (nonatomic, readonly) float maxVelocity;
@property (nonatomic, readonly) float minDuration;
@property (nonatomic, readonly) float currentDuration;

-(void) resetCurrentDuration;
-(void) increaseCurrentDuration:(float)delta;

@end
