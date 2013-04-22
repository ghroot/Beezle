//
// Created by Marcus on 21/04/2013.
//

#import "GameState.h"
#import "artemis.h"

@class RenderSystem;
@class PhysicsSystem;
@class DebugRenderPhysicsSystem;

@interface TestVisualState : GameState
{
	NSString *_levelName;
	World *_world;
	PhysicsSystem *_physicsSystem;
	RenderSystem *_renderSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
	CCLayer *_gameLayer;
}

+(TestVisualState *) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;

@end
