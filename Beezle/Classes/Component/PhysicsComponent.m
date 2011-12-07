//
//  PhysicalBehaviour.m
//
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsComponent.h"
#import "PhysicsBody.h"
#import "PhysicsShape.h"

@implementation PhysicsComponent

@synthesize physicsBody = _physicsBody;
@synthesize physicsShapes = _physicsShapes;

+(id) componentWithBody:(PhysicsBody *)body andShapes:(NSArray *)shapes
{
	return [[[self alloc] initWithBody:body andShapes:shapes] autorelease];
}

+(id) componentWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape
{
	return [[[self alloc] initWithBody:body andShape:shape] autorelease];
}

-(id) initWithBody:(PhysicsBody *)body andShapes:(NSArray *)shapes
{
    if (self = [super init])
    {
        _physicsBody = [body retain];
        _physicsShapes = [shapes retain];
    }
    return self;
}

-(id) initWithBody:(PhysicsBody *)body andShape:(PhysicsShape *)shape
{
    self = [self initWithBody:body andShapes:[NSMutableArray arrayWithObject:shape]];
    return self;
}

- (void)dealloc
{
    [_physicsShapes release];
    [_physicsBody release];
    
    [super dealloc];
}

-(PhysicsShape *) firstPhysicsShape
{
    return [_physicsShapes objectAtIndex:0];
}

@end
