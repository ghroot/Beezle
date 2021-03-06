//
//  EditState.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"

@class BeeaterSystem;
@class BeeQueueRenderingSystem;
@class DebugRenderPhysicsSystem;
@class EditControlSystem;
@class EditOptionsSystem;
@class InputSystem;
@class MovementSystem;
@class RenderSystem;
@class PhysicsSystem;
@class TeleportSystem;

@interface EditState : GameState
{
	NSString *_levelName;

	int _pollenForTwoFlowers;
	int _pollenForThreeFlowers;

	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	
	World *_world;
	
    RenderSystem *_renderSystem;
	PhysicsSystem *_physicsSystem;
	MovementSystem *_movementSystem;
	TeleportSystem *_teleportSystem;
    InputSystem *_inputSystem;
	EditControlSystem *_editControlSystem;
	EditOptionsSystem *_editOptionsSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
	BeeaterSystem *_beeaterSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic) int pollenForTwoFlowers;
@property (nonatomic) int pollenForThreeFlowers;
@property (nonatomic, readonly) World *world;


+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;

-(void) addEntityWithType:(NSString *)type instanceComponentsDict:(NSDictionary *)instanceComponentsDict;
-(void) addEntityWithType:(NSString *)type;
-(void) toggleDebugPhysicsDrawing;
-(void) pauseGame:(id)sender;

@end
