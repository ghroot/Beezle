//
//  EditState.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"

@class DebugRenderPhysicsSystem;
@class EditControlSystem;
@class InputSystem;
@class RenderSystem;
@class PhysicsSystem;

@interface EditState : GameState
{
	NSString *_levelName;
	
	CCLayer *_gameLayer;
	
	World *_world;
	
    RenderSystem *_renderSystem;
	PhysicsSystem *_physicsSystem;
    InputSystem *_inputSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
	EditControlSystem *_editControlSystem;
}

+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;

@end
