//
//  PhysicsSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"
#import "CollisionTypes.h"

@class PhysicsComponent;

@interface PhysicsSystem : EntityComponentSystem
{
    cpSpace *_space;
}

@property (nonatomic, readonly) cpSpace *space;

-(PhysicsComponent *) createPhysicsComponentWithFile:(NSString *)fileName bodyName:(NSString *)bodyName isStatic:(BOOL)isStatic collisionType:(int)collisionType;
-(void) detectBeforeCollisionsBetween:(CollisionType)type1 and:(CollisionType)type2;
-(void) detectAfterCollisionsBetween:(CollisionType)type1 and:(CollisionType)type2;

@end
