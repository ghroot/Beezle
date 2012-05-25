//
//  Collision.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Collision.h"
#import "PhysicsComponent.h"

@implementation Collision

@synthesize firstShape = _firstShape;
@synthesize secondShape = _secondShape;

+(id) collisionWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape
{
	return [[[self alloc] initWithFirstShape:firstShape andSecondShape:secondShape] autorelease];
}

-(id) initWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape
{
    if (self = [super init])
    {
        _firstShape = [firstShape retain];
        _secondShape = [secondShape retain];
    }
    return self;
}

-(void) dealloc
{
	[_firstShape release];
	[_secondShape release];
    
    [super dealloc];
}

-(Entity *) firstEntity
{
    return [_firstShape data];
}

-(Entity *) secondEntity
{
    return [_secondShape data];
}

-(float) firstEntityVelocityTimesMass
{
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:[self firstEntity]];
    ChipmunkBody *body = [physicsComponent body];
    float velocityTimesMass = cpvlength([body vel]) * [body mass];
    return velocityTimesMass;
}

-(float) secondEntityVelocityTimesMass
{
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:[self secondEntity]];
    ChipmunkBody *body = [physicsComponent body];
    float velocityTimesMass = cpvlength([body vel]) * [body mass];
    return velocityTimesMass;
}

@end
