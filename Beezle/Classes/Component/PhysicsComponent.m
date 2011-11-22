//
//  PhysicalBehaviour.m
//
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"
#import "PhysicsBody.h"
#import "PhysicsShape.h"

@implementation PhysicsComponent

@synthesize body = _body;
@synthesize shapes = _shapes;

-(id) initWithBody:(PhysicsBody *)body andShapes:(NSMutableArray *)shapes
{
    if (self = [super init])
    {
        _body = [body retain];
        _shapes = [shapes retain];
    }
    return self;
}

-(id) initWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape
{
    self = [self initWithBody:body andShapes:[[NSMutableArray alloc] initWithObjects:shape, nil]];
    return self;
}

- (void)dealloc
{
    [_shapes release];
    [_body release];
    
    [super dealloc];
}

-(PhysicsShape *) shape
{
    return [_shapes objectAtIndex:0];
}

@end
