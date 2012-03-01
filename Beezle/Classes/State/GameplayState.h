//
//  GameplayState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"
#import "cocos2d.h"
#import "GameMode.h"

@class BeeaterSystem;
@class BeeExpiratonSystem;
@class ExplodeControlSystem;
@class BeeQueueRenderingSystem;
@class CollisionSystem;
@class DebugNotificationTrackerSystem;
@class DebugRenderPhysicsSystem;
@class GameRulesSystem;
@class GateOpeningSystem;
@class ShardSystem;
@class HUDRenderingSystem;
@class InputSystem;
@class LevelSession;
@class MovementSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;
@class SpawnSystem;

@interface GameplayState : GameState
{
	NSString *_levelName;
	LevelSession *_levelSession;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	
	NSMutableArray *_notifications;

	World *_world;
	
	BOOL _debug;
	
    GameRulesSystem *_gameRulesSystem;
    PhysicsSystem *_physicsSystem;
	MovementSystem *_movementSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
	HUDRenderingSystem *_hudRenderingSystem;
    InputSystem *_inputSystem;
    SlingerControlSystem *_slingerControlSystem;
    BeeExpiratonSystem *_beeExpirationSystem;
	ExplodeControlSystem *_explodeControlSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
	BeeaterSystem *_beeaterSystem;
	GateOpeningSystem *_gateOpeningSystem;
	ShardSystem *_shardSystem;
	SpawnSystem *_spawnSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
	DebugNotificationTrackerSystem *_debugNotificationTrackerSystem;
    
    GameMode *_currentMode;
    GameMode *_aimingMode;
    GameMode *_shootingMode;
    GameMode *_levelCompletedMode;
    GameMode *_levelFailedMode;
}

@property (nonatomic, readonly) NSString *levelName;

+(id) stateWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession;
+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession;
-(id) initWithLevelName:(NSString *)levelName;
-(void) pauseGame:(id)sender;

@end
