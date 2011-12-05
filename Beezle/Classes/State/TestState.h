//
//  TestState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameState.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"
#import "slick.h"

@class DebugRenderPhysicsSystem;
@class PhysicsSystem;
@class RenderSystem;

@interface TestState : CocosGameState
{
    World *_world;
    
    PhysicsSystem *_physicsSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    
	int _interval;
    int _countdown;
	
    CCLabelTTF *_label;
}

@end
