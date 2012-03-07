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
	
	BeeaterSystem *_beeaterSystem;
    BeeExpiratonSystem *_beeExpirationSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
    CollisionSystem *_collisionSystem;
	ExplodeControlSystem *_explodeControlSystem;
    GameRulesSystem *_gameRulesSystem;
	GateOpeningSystem *_gateOpeningSystem;
	HUDRenderingSystem *_hudRenderingSystem;
    InputSystem *_inputSystem;
	MovementSystem *_movementSystem;
    PhysicsSystem *_physicsSystem;
    RenderSystem *_renderSystem;
	ShardSystem *_shardSystem;
    SlingerControlSystem *_slingerControlSystem;
	SpawnSystem *_spawnSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
	DebugNotificationTrackerSystem *_debugNotificationTrackerSystem;
    
    NSMutableArray *_modes;
    GameMode *_currentMode;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) World *world;
@property (nonatomic, readonly) BeeaterSystem *beeaterSystem;
@property (nonatomic, readonly) BeeExpiratonSystem *beeExpirationSystem;
@property (nonatomic, readonly) BeeQueueRenderingSystem *beeQueueRenderingSystem;
@property (nonatomic, readonly) CollisionSystem *collisionSystem;
@property (nonatomic, readonly) ExplodeControlSystem *explodeControlSystem;
@property (nonatomic, readonly) GameRulesSystem *gameRulesSystem;
@property (nonatomic, readonly) GateOpeningSystem *gateOpeningSystem;
@property (nonatomic, readonly) HUDRenderingSystem *hudRenderingSystem;
@property (nonatomic, readonly) InputSystem *inputSystem;
@property (nonatomic, readonly) MovementSystem *movementSystem;
@property (nonatomic, readonly) PhysicsSystem *physicsSystem;
@property (nonatomic, readonly) RenderSystem *renderSystem;
@property (nonatomic, readonly) ShardSystem *shardSystem;
@property (nonatomic, readonly) SlingerControlSystem *slingerControlSystem;
@property (nonatomic, readonly) SpawnSystem *spawnSystem;

+(id) stateWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession;
+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession;
-(id) initWithLevelName:(NSString *)levelName;
-(void) pauseGame:(id)sender;

@end
