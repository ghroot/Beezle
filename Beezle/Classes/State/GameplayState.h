//
//  GameplayState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"
#import "slick.h"

@class BoundrySystem;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class InputSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;

@interface GameplayState : GameState
{
	World *_world;
	
	BOOL _debug;
	
    PhysicsSystem *_physicsSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    InputSystem *_inputSystem;
    SlingerControlSystem *_slingerControlSystem;
    BoundrySystem *_boundrySystem;
}

@end