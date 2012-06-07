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
#import "CollisionSystem.h"
#import "ObjectiveChipmunk.h"

@class BodyInfo;
@class PhysicsComponent;

#define FIXED_TIMESTEP (1.0f / 45.0f)

@interface PhysicsSystem : EntityComponentSystem
{
	ComponentMapper *_transformComponentMapper;
	ComponentMapper *_physicsComponentMapper;
    CollisionSystem *_collisionSystem;
    
    ChipmunkSpace *_space;
    NSMutableArray *_loadedShapeFileNames;
}

@property (nonatomic, readonly) ChipmunkSpace *space;

-(BodyInfo *) createBodyInfoFromFile:(NSString *)fileName bodyName:(NSString *)bodyName scale:(float)scale;
-(BodyInfo *) createBodyInfoFromFile:(NSString *)fileName bodyName:(NSString *)bodyName;

@end
