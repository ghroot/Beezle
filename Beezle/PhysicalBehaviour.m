//
//  PhysicalBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicalBehaviour.h"

#import "Actor.h"

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

-(void) update:(ccTime) delta
{
    // TODO: Have coordinator handle behaviour interactions
    
    if ([_parentActor hasBehaviour:@"renderable"])
    {
        RenderableBehaviour *renderableBehaviour = (RenderableBehaviour *)[_parentActor getBehaviour:@"renderable"];
        [renderableBehaviour setPosition:_body->p];
    }
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
