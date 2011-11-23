//
//  DebugRenderPhysicsSystem.m
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsSystem.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"

@implementation DebugRenderPhysicsSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[PhysicsComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    for (PhysicsShape *physicsShape in [physicsComponent physicsShapes])
    {
        cpShape *shape = [physicsShape shape];   
        [self drawShape:shape];   
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
