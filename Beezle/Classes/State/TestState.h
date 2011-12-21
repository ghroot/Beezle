//
//  TestState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"

#import "cocos2d.h"

@class DebugRenderPhysicsSystem;
@class PhysicsSystem;
@class RenderSystem;

@interface TestState : GameState
{
	CCLayer *_layer;

    World *_world;
    
    PhysicsSystem *_physicsSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    
	int _interval;
    int _countdown;
	
    CCLabelTTF *_label;
}

@end
