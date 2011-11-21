//
//  CircularBoundry.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Boundry.h"
#import "cocos2d.h"

@interface CircularBoundry : Boundry
{
    CGPoint _centerLocation;
    float _radius;
}

-(id) initWithCenterLocation:(CGPoint)centerLocation andRadius:(float)radius;

@end
