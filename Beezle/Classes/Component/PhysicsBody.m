//
//  PhysicsBody.m
//  Beezle
//
//  Created by Me on 22/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsBody.h"

@implementation PhysicsBody

@synthesize body = _body;

+(id) physicsBodyWithBody:(cpBody *)body
{
	return [[[self alloc] initWithBody:body] autorelease];
}

-(id) initWithBody:(cpBody *)body
{
    if (self = [super init])
    {
        _body = body;
    }
    return self;
}

- (void)dealloc
{
	cpBodyFree(_body);
    
    [super dealloc];
}

@end
