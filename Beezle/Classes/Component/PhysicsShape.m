//
//  PhysicsShape.m
//  Beezle
//
//  Created by Me on 22/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsShape.h"

@implementation PhysicsShape

@synthesize shape = _shape;

-(id) initWithShape:(cpShape *)shape
{
    if (self = [super init])
    {
        _shape = shape;
    }
    return self;
}

- (void)dealloc
{
    cpShapeFree(_shape);
    
    [super dealloc];
}

@end
