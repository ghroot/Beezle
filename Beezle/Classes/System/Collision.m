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

@synthesize firstEntity = _firstEntity;
@synthesize secondEntity = _secondEntity;
@synthesize type1 = _type1;
@synthesize type2 = _type2;
@synthesize impulse = _impulse;

+(id) collisionWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity
{
	return [[[self alloc] initWithFirstEntity:firstEntity andSecondEntity:secondEntity] autorelease];
}

-(id) initWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity
{
    if (self = [super init])
    {
        _firstEntity = [firstEntity retain];
        _secondEntity = [secondEntity retain];
    }
    return self;
}

-(void) dealloc
{
    [_firstEntity release];
    [_secondEntity release];
    
    [super dealloc];
}

-(float) impulseLength
{
    return cpvlength(_impulse);
}


@end
