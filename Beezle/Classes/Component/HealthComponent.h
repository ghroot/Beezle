//
//  HealthComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Restores disposed entities until health points run out.
 */
@interface HealthComponent : Component
{
	int _totalHealthPoints;
	int _healthPointsLeft;
}

-(void) resetHealthPointsLeft;
-(void) deductHealthPoint;
-(BOOL) hasHealthPointsLeft;

@end
