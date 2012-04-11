//
//  Collision.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Collision.h"
#import "CollisionType.h"
#import "PhysicsComponent.h"

@implementation Collision

@synthesize firstShape = _firstShape;
@synthesize secondShape = _secondShape;
@synthesize impulse = _impulse;

+(id) collisionWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape impulse:(cpVect)impulse
{
	return [[[self alloc] initWithFirstShape:firstShape andSecondShape:secondShape impulse:impulse] autorelease];
}

-(id) initWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape impulse:(cpVect)impulse
{
    if (self = [super init])
    {
        _firstShape = [firstShape retain];
        _secondShape = [secondShape retain];
        _impulse = impulse;
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

-(CollisionType *) firstCollisionType
{
    return [_firstShape collisionType];
}

-(CollisionType *) secondCollisionType
{
    return [_secondShape collisionType];
}

-(float) impulseLength
{
    return cpvlength(_impulse);
}


@end
