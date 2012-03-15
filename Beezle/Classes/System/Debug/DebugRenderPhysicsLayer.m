//
//  DebugRenderPhysicsLayer.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsLayer.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

@interface DebugRenderPhysicsLayer()

-(void) drawShape:(ChipmunkShape *)shape;
-(void) drawAnchorPoint:(CGPoint)position;

@end

@implementation DebugRenderPhysicsLayer

@synthesize entitiesToDraw = _entitiesToDraw;

-(id) init
{
    if (self = [super init])
    {
        _entitiesToDraw = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_entitiesToDraw release];
    
    [super dealloc];
}

-(void) draw
{
	ccDrawColor4F(255.0f, 255.0f, 255.0f, 1.0f);
	
	for (Entity *entity in _entitiesToDraw)
	{
		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
		for (ChipmunkShape *shape in [physicsComponent shapes])
		{
			[self drawShape:shape];
		}
		
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		[self drawAnchorPoint:[transformComponent position]];
	}
}

-(void) drawShape:(ChipmunkShape *)shape
{	
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

-(void) drawAnchorPoint:(CGPoint)position
{
	ccDrawCircle(position, 4.5f, 0, 8, FALSE);
	ccDrawLine(CGPointMake(position.x, position.y + 4), CGPointMake(position.x, position.y - 4));
	ccDrawLine(CGPointMake(position.x - 4, position.y), CGPointMake(position.x + 4, position.y));
}

@end
