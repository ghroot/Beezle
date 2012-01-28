//
//  MovementComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementComponent.h"

@implementation MovementComponent

@synthesize points = _points;
@synthesize currentPointIndex = _currentPointIndex;

-(void) dealloc
{
	[_points release];
	
	[super dealloc];
}

@end
