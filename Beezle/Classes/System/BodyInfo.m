//
//  BodyInfo.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyInfo.h"
#import "PhysicsBody.h"
#import "PhysicsShape.h"

@implementation BodyInfo

@synthesize physicsBody = _physicsBody;
@synthesize physicsShapes = _physicsShapes;

-(id) init
{
    if (self = [super init])
    {
        _physicsShapes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_physicsBody release];
    [_physicsShapes release];
    
    [super dealloc];
}

-(void) setBody:(cpBody *)body
{
    _physicsBody = [[PhysicsBody alloc] initWithBody:body];
}

-(void) addShape:(cpShape *)shape
{
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    [_physicsShapes addObject:physicsShape];
}

@end
