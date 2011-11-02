//
//  PhysicsSprite.m
//  Beezle
//
//  Created by Me on 02/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSprite.h"

@implementation PhysicsSprite

-(void) setPhysicsBody:(cpBody *)body
{
	_body = body;
}

// This method will only get called if the sprite is batched.
// Return YES if the physics values (angles, position ) changed
// If you return NO, then nodeToParentTransform won't be called.
-(BOOL) dirty
{
	return YES;
}

// Returns the transform matrix according the Chipmunk Body values
-(CGAffineTransform) nodeToParentTransform
{	
	CGFloat x = _body->p.x;
	CGFloat y = _body->p.y;
	
	if (!isRelativeAnchorPoint_)
    {
		x += anchorPointInPoints_.x;
		y += anchorPointInPoints_.y;
	}
	
	// Make matrix
	CGFloat c = _body->rot.x;
	CGFloat s = _body->rot.y;
	
	if(!CGPointEqualToPoint(anchorPointInPoints_, CGPointZero))
    {
		x += c*-anchorPointInPoints_.x + -s*-anchorPointInPoints_.y;
		y += s*-anchorPointInPoints_.x + c*-anchorPointInPoints_.y;
	}
	
	// Translate, Rot, anchor Matrix
	transform_ = CGAffineTransformMake(c,  s,
									   -s,	c,
									   x,	y);
	
	return transform_;
}

void removeShape(cpBody* body, cpShape* shape, void* data)
{
	cpShapeFree(shape);
}

-(void) dealloc
{
	cpBodyEachShape(_body, removeShape, NULL);
	cpBodyFree(_body);
	
	[super dealloc];
}

@end
