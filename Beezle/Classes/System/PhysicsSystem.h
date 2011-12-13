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

@class PhysicsComponent;

@interface PhysicsSystem : EntityComponentSystem
{
    cpSpace *_space;
    NSMutableArray *_loadedShapeFileNames;
}

@property (nonatomic, readonly) cpSpace *space;

-(PhysicsComponent *) createPhysicsComponentWithFile:(NSString *)fileName bodyName:(NSString *)bodyName isStatic:(BOOL)isStatic collisionType:(cpCollisionType)collisionType;
-(void) detectBeforeCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2;
-(void) detectAfterCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2;

@end
