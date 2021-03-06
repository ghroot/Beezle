//
//  Collision.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "ObjectiveChipmunk.h"

@class Entity;

@interface Collision : NSObject
{
    ChipmunkShape *_firstShape;
	ChipmunkShape *_secondShape;
}

@property (nonatomic, readonly) ChipmunkShape *firstShape;
@property (nonatomic, readonly) ChipmunkShape *secondShape;

+(id) collisionWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShape;

-(id) initWithFirstShape:(ChipmunkShape *)firstShape andSecondShape:(ChipmunkShape *)secondShapee;

-(Entity *) firstEntity;
-(Entity *) secondEntity;
-(float) firstEntityVelocityTimesMass;
-(float) secondEntityVelocityTimesMass;

@end
