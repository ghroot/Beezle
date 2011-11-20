//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "SystemManager.h"
#import "World.h"

@class EntityManager;
@class PhysicsSystem;
@class CollisionSystem;
@class RenderSystem;
@class DebugRenderPhysicsSystem;
@class InputSystem;
@class SlingerControlSystem;
@class BoundrySystem;

@interface GameLayer : CCLayer
{
    World *_world;
    
    PhysicsSystem *_physicsSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    InputSystem *_inputSystem;
    SlingerControlSystem *_slingerControlSystem;
    BoundrySystem *_boundrySystem;
    
    BOOL isTouching;
    CGPoint touchStartLocation;
    CGPoint touchVector;
}

@end
