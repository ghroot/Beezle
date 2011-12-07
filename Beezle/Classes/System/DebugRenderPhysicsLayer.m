//
//  DebugRenderPhysicsLayer.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsLayer.h"
#import "PhysicsShape.h"

@implementation DebugRenderPhysicsLayer

@synthesize shapesToDraw = _shapesToDraw;

-(id) init
{
    if (self = [super init])
    {
        _shapesToDraw = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) draw
{
    for (PhysicsShape *physicsShape in _shapesToDraw)
    {
        [self drawShape:[physicsShape shape]];
    }
}

-(void) drawShape:(cpShape *)shape
{
    if (shape->klass_private->type == CP_CIRCLE_SHAPE)
    {
        cpCircleShape* circleShape = (cpCircleShape*)shape;
        cpVect c = cpvadd(shape->body->p, cpvrotate(circleShape->c, shape->body->rot));
        ccDrawCircle(c, circleShape->r, shape->body->a, 20, TRUE);
    }
    else if (shape->klass_private->type == CP_POLY_SHAPE)
    {
        cpPolyShape* polyShape = (cpPolyShape*)shape;
        ccDrawPoly(polyShape->tVerts, polyShape->numVerts, YES);
    }
    else if (shape->klass_private->type == CP_SEGMENT_SHAPE)
    {
        cpSegmentShape* segmentShape = (cpSegmentShape*)shape;
        ccDrawLine(segmentShape->ta, segmentShape->tb);
    }
    else
    {
        cpSegmentShape* segmentShape = (cpSegmentShape*)shape;
        ccDrawLine(segmentShape->ta, segmentShape->tb);
    }
}

@end
