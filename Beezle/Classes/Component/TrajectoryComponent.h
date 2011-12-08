//
//  TrajectoryComponent.h
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface TrajectoryComponent : Component
{
	CGPoint _startPoint;
	float _power;
	float _angle;
}

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) float power;
@property (nonatomic) float angle;

-(BOOL) isZero;
-(void) reset;

@end
