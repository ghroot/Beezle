//
//  TestState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"
#import "slick.h"

@class BoundrySystem;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;
@class TestEntitySpawningSystem;

@interface TestState : GameState
{
    World *_world;
    
    PhysicsSystem *_physicsSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    SlingerControlSystem *_slingerControlSystem;
    BoundrySystem *_boundrySystem;
    TestEntitySpawningSystem *_testEntitySpawningSystem;
    
    CCLabelTTF *_label;
}

@end
