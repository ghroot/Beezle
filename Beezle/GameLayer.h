//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "artemis.h"

@class BoundrySystem;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class InputSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;

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
