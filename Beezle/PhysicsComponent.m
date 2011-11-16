//
//  PhysicalBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"

#import "Entity.h"

@implementation PhysicsComponent

@synthesize body = _body;
@synthesize shape = _shape;

- (id)initWithBody:(cpBody *)body andShape:(cpShape *)shape
{
    if (self = [self init])
    {
        _body = body;
        _shape = shape;
    }
    return self;
}

- (void)dealloc
{
    cpShapeFree(_shape);
	cpBodyFree(_body);
    
    [super dealloc];
}

@end
