//
//  PhysicalBehaviour.m
//
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"

@implementation PhysicsComponent

@synthesize body = _body;
@synthesize shapes = _shapes;
@synthesize positionUpdatedManually = _positionUpdatedManually;
@synthesize isRougeBody = _isRougeBody;

+(id) componentWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
	return [[[self alloc] initWithBody:body andShapes:shapes] autorelease];
}

+(id) componentWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape
{
	return [[[self alloc] initWithBody:body andShape:shape] autorelease];
}

-(id) initWithBody:(ChipmunkBody *)body andShapes:(NSArray *)shapes
{
    if (self = [super init])
    {
        _body = [body retain];
        _shapes = [shapes retain];
		_positionUpdatedManually = FALSE;
    }
    return self;
}

-(id) initWithBody:(ChipmunkBody *)body andShape:(ChipmunkShape *)shape
{
    self = [self initWithBody:body andShapes:[NSMutableArray arrayWithObject:shape]];
    return self;
}

- (void)dealloc
{
    [_shapes release];
    [_body release];
    
    [super dealloc];
}

-(ChipmunkShape *) firstPhysicsShape
{
    return [_shapes objectAtIndex:0];
}

-(void) setPositionManually:(CGPoint)position
{
	[_body setPos:position];
	_positionUpdatedManually = TRUE;
}

-(void) setRotationManually:(float)rotation
{
	[_body setAngle:CC_DEGREES_TO_RADIANS(-rotation)];
}

@end
