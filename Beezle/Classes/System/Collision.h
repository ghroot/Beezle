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
	ChipmunkShape *_shape1;
	ChipmunkShape *_shape2;
	CollisionType *_type1;
	CollisionType *_type2;
	cpVect _impulse;
}

@property (nonatomic, readonly) Entity *firstEntity;
@property (nonatomic, readonly) Entity *secondEntity;
@property (nonatomic, retain) ChipmunkShape *shape1;
@property (nonatomic, retain) ChipmunkShape *shape2;
@property (nonatomic, assign) CollisionType *type1;
@property (nonatomic, assign) CollisionType *type2;
@property (nonatomic) cpVect impulse;

+(id) collisionWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity;

-(id) initWithFirstEntity:(Entity *)firstEntity andSecondEntity:(Entity *)secondEntity;

-(float) impulseLength;

@end
