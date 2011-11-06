//
//  TestActor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestPhysicalActor.h"

@implementation TestPhysicalActor

- (id)init
{
    if (self = [super init])
    {
        RenderableBehaviour *renderableBehaviour = [[RenderableBehaviour alloc] initWithFile:@"BeeSlingerC-01.png"];
        renderableBehaviour.name = @"renderable";
        [self addBehaviour:renderableBehaviour];
        
        CGPoint verts[] =
        {
            ccp(-10,-10),
            ccp(-10, 100),
            ccp( 10, 100),
            ccp( 10,-10),
        };
        cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, 4, verts, CGPointZero));
        cpShape* shape = cpPolyShapeNew(body, 4, verts, CGPointZero);
        shape->e = 0.5f;
        shape->u = 0.5f;
        PhysicalBehaviour *physicalBehaviour = [[PhysicalBehaviour alloc] initWithBody:body andShape:shape];
        physicalBehaviour.name = @"physical";
        [self addBehaviour:physicalBehaviour];
    }
    return self;
}

@end
