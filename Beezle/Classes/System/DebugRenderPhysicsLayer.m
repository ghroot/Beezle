//
//  DebugRenderPhysicsLayer.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsLayer.h"

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

-(void) dealloc
{
    [_shapesToDraw release];
    
    [super dealloc];
}

-(void) draw
{
    for (ChipmunkShape *shape in _shapesToDraw)
    {
        [self drawShape:shape];
    }
}

-(void) drawShape:(ChipmunkShape *)shape
{	
    ccDrawColor4f(255.0f, 255.0f, 255.0f, 1.0f);
	if ([shape isKindOfClass:[ChipmunkCircleShape class]])
    {
		cpBody *body = [[shape body] body];
        cpCircleShape *circleShape = (cpCircleShape *)[shape shape];
        cpVect c = cpvadd(body->p, cpvrotate(circleShape->c, body->rot));
        ccDrawCircle(c, circleShape->r, body->a, 20, TRUE);
    }
	else if ([shape isKindOfClass:[ChipmunkPolyShape class]])
    {
        cpPolyShape *polyShape = (cpPolyShape*)[shape shape];
        ccDrawPoly(polyShape->tVerts, polyShape->numVerts, YES);
    }
	else if ([shape isKindOfClass:[ChipmunkSegmentShape class]])
    {
        cpSegmentShape* segmentShape = (cpSegmentShape*)[shape shape];
        ccDrawLine(segmentShape->ta, segmentShape->tb);
    }
}

@end
