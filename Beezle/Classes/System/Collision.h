//
//  Collision.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "ObjectiveChipmunk.h"
#import "CollisionType.h"

@class Entity;

@interface Collision : NSObject
{
    Entity *_firstEntity;
    Entity *_secondEntity;
	cpVect _impulse;
}

@property (nonatomic, readonly) Entity *firstEntity;
@property (nonatomic, readonly) Entity *secondEntity;
@property (nonatomic) cpVect impulse;

+(id) collisionWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity;

-(id) initWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity;

-(CollisionType *) type1;
-(CollisionType *) type2;

-(float) impulseLength;

@end
