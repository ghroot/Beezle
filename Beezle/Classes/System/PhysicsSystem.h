//
//  PhysicsSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

@class BodyInfo;
@class CollisionType;
@class PhysicsComponent;

@interface PhysicsSystem : EntityComponentSystem
{
    ChipmunkSpace *_space;
    NSMutableArray *_loadedShapeFileNames;
}

@property (nonatomic, readonly) ChipmunkSpace *space;

-(BodyInfo *) createBodyInfoFromFile:(NSString *)fileName bodyName:(NSString *)bodyName collisionType:(CollisionType *)collisionType;
-(void) detectBeforeCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2;
-(void) detectAfterCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2;
-(BOOL) beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void) postSolveCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

@end
