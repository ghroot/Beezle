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
    ChipmunkShape *_firstShape;
	ChipmunkShape *_secondShape;
	cpVect _impulse;
}

@property (nonatomic, readonly) ChipmunkShape *firstShape;
@property (nonatomic, readonly) ChipmunkShape *secondShape;
@property (nonatomic, readonly) cpVect impulse;

+(id) collisionWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape impulse:(cpVect)impulse;

-(id) initWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape impulse:(cpVect)impulse;

-(Entity *) firstEntity;
-(Entity *) secondEntity;
-(CollisionType *) firstCollisionType;
-(CollisionType *) secondCollisionType;
-(float) impulseLength;

@end
