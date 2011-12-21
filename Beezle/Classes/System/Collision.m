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

@synthesize firstEntity = _firstEntity;
@synthesize secondEntity = _secondEntity;

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

-(cpCollisionType) type1
{
	PhysicsComponent *firstPhysicsComponent = (PhysicsComponent *)[_firstEntity getComponent:[PhysicsComponent class]];
	return [[firstPhysicsComponent firstPhysicsShape] shape]->collision_type;
}

-(cpCollisionType) type2
{
	PhysicsComponent *secondPhysicsComponent = (PhysicsComponent *)[_secondEntity getComponent:[PhysicsComponent class]];
	return [[secondPhysicsComponent firstPhysicsShape] shape]->collision_type;
}


@end
