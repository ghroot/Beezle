//
//  CircularBoundry.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CircularBoundry.h"

#import "cocos2d.h"

@implementation CircularBoundry

-(id) initWithCenterLocation:(CGPoint)centerLocation andRadius:(float)radius
{
    if (self = [super init])
    {
        _centerLocation = centerLocation;
        _radius = radius;
    }
    return self;
}

-(CGPoint) getEnforcedLocation:(CGPoint)position
{
    float currentRadius = ccpDistance(_centerLocation, position);
    if (currentRadius > _radius)
    {
        float angle = ccpToAngle(ccpSub(position, _centerLocation));
        float newX = _centerLocation.x + cos(angle) * _radius;
        float newY = _centerLocation.y + sin(angle) * _radius;
        return ccp(newX, newY);
    }
    else
    {
        return position;
    }
}

@end
