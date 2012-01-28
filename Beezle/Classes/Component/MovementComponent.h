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
	NSMutableArray *_points;
	int _currentPointIndex;
}

@property (nonatomic, retain) NSArray *points;
@property (nonatomic) int currentPointIndex;

@end
