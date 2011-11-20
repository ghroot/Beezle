//
//  DebugRenderPhysicsSystem.m
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsSystem.h"
#import "PhysicsSystem.h"
#import "PhysicsComponent.h"
#import "World.h"

@implementation DebugRenderPhysicsSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[PhysicsComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [physicsComponent body];
    cpShape *shape = [physicsComponent shape];
    
    if (shape->klass_private->type == CP_CIRCLE_SHAPE)
    {
        cpCircleShape *circleShape = (cpCircleShape *)shape;
        ccDrawCircle(body->p, circleShape->r, body->a, 30, TRUE);
    }
    else if (shape->klass_private->type == CP_POLY_SHAPE)
    {
        cpPolyShape *polyShape = (cpPolyShape *)shape;
        for (int i = 0; i < polyShape->numVerts; i++)
        {
            ccDrawPoly(polyShape->tVerts, polyShape->numVerts, TRUE);
        }
    }
    else if (shape->klass_private->type == CP_SEGMENT_SHAPE)
    {
        cpSegmentShape* segmentShape = (cpSegmentShape*)shape;
        ccDrawLine(segmentShape->ta, segmentShape->tb);
    }
}

@end
