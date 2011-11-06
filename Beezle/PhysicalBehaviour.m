//
//  PhysicalBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicalBehaviour.h"

@implementation PhysicalBehaviour

- (id)initWithBody:(cpBody *)body andShape:(cpShape *)shape
{
    if (self = [super init])
    {
        _body = body;
        _shape = shape;
    }
    return self;
}

-(cpBody *) body
{
    return _body;
}

-(cpShape *) shape
{
    return _shape;
}

-(void) addedToLayer:(GameLayer *)layer
{
    cpSpaceAddBody([layer space], _body);
    cpSpaceAddShape([layer space], _shape);
}

-(void) removedFromLayer:(GameLayer *)layer
{
    cpSpaceRemoveBody([layer space], _body);
    cpSpaceRemoveShape([layer space], _shape);
}

-(void) setPosition:(CGPoint)position
{
    _body->p = position;
}

void removeShape(cpBody *body, cpShape *shape, void *data)
{
	cpShapeFree(shape);
}

- (void)dealloc
{
    cpBodyEachShape(_body, removeShape, NULL);
	cpBodyFree(_body);
    
    [super dealloc];
}

@end
