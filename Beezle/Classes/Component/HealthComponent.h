//
//  HealthComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface HealthComponent : Component
{
	int _totalHealthPoints;
	int _healthPointsLeft;
}

-(void) resetHealthPointsLeft;
-(void) deductHealthPoint;
-(BOOL) hasHealthPointsLeft;

@end
