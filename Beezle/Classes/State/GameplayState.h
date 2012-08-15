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

@class AimPollenShooterSystem;
@class BeeaterSystem;
@class BeeExpiratonSystem;
@class ExplodeControlSystem;
@class BeeQueueRenderingSystem;
@class CapturedSystem;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class DisposalSystem;
@class FreezeSystem;
@class GameRulesSystem;
@class HealthSystem;
@class HUDRenderingSystem;
@class InputSystem;
@class LevelSession;
@class MovementSystem;
@class PhysicsSystem;
@class RenderSystem;
@class ShakeSystem;
@class ShardSystem;
@class SlingerControlSystem;
@class SpawnSystem;
@class WaterWaveSystem;
@class FollowControlSystem;
@class DestructControlSystem;
@class FadeSystem;
@class SandSystem;
@class TeleportSystem;

@interface GameplayState : GameState
{
	NSString *_levelName;
	LevelSession *_levelSession;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	CCMenuItemImage *_pauseMenuItem;

	World *_world;
	
	BOOL _debug;
	
	BeeaterSystem *_beeaterSystem;
	CapturedSystem *_capturedSystem;
    BeeExpiratonSystem *_beeExpirationSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
	WaterWaveSystem *_waterWaveSystem;
    CollisionSystem *_collisionSystem;
	ExplodeControlSystem *_explodeControlSystem;
    GameRulesSystem *_gameRulesSystem;
	FreezeSystem *_freezeSystem;
	FadeSystem *_fadeSystem;
	HUDRenderingSystem *_hudRenderingSystem;
    InputSystem *_inputSystem;
	MovementSystem *_movementSystem;
	TeleportSystem *_teleportSystem;
    PhysicsSystem *_physicsSystem;
    RenderSystem *_renderSystem;
	ShardSystem *_shardSystem;
    SlingerControlSystem *_slingerControlSystem;
	AimPollenShooterSystem *_aimPollenShooterSystem;
	DestructControlSystem *_destructControlSystem;
	FollowControlSystem *_followControlSystem;
	SpawnSystem *_spawnSystem;
	SandSystem *_sandSystem;
	ShakeSystem *_shakeSystem;
	HealthSystem *_healthSystem;
	DisposalSystem *_disposalSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    
    NSMutableArray *_modes;
    GameMode *_currentMode;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) World *world;
@property (nonatomic, readonly) AimPollenShooterSystem *aimPollenShooterSystem;
@property (nonatomic, readonly) BeeaterSystem *beeaterSystem;
@property (nonatomic, readonly) BeeExpiratonSystem *beeExpirationSystem;
@property (nonatomic, readonly) BeeQueueRenderingSystem *beeQueueRenderingSystem;
@property (nonatomic, readonly) CapturedSystem *capturedSystem;
@property (nonatomic, readonly) CollisionSystem *collisionSystem;
@property (nonatomic, readonly) DestructControlSystem *destructControlSystem;
@property (nonatomic, readonly) DisposalSystem *disposalSystem;
@property (nonatomic, readonly) ExplodeControlSystem *explodeControlSystem;
@property (nonatomic, readonly) FadeSystem *fadeSystem;
@property (nonatomic, readonly) FollowControlSystem *followControlSystem;
@property (nonatomic, readonly) FreezeSystem *freezeSystem;
@property (nonatomic, readonly) GameRulesSystem *gameRulesSystem;
@property (nonatomic, readonly) HealthSystem *healthSystem;
@property (nonatomic, readonly) HUDRenderingSystem *hudRenderingSystem;
@property (nonatomic, readonly) InputSystem *inputSystem;
@property (nonatomic, readonly) MovementSystem *movementSystem;
@property (nonatomic, readonly) PhysicsSystem *physicsSystem;
@property (nonatomic, readonly) RenderSystem *renderSystem;
@property (nonatomic, readonly) SandSystem *sandSystem;
@property (nonatomic, readonly) ShakeSystem *shakeSystem;
@property (nonatomic, readonly) ShardSystem *shardSystem;
@property (nonatomic, readonly) SlingerControlSystem *slingerControlSystem;
@property (nonatomic, readonly) SpawnSystem *spawnSystem;
@property (nonatomic, readonly) TeleportSystem *teleportSystem;
@property (nonatomic, readonly) WaterWaveSystem *waterWaveSystem;


+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;
-(void) pauseGame:(id)sender;
-(void) hidePauseButton;
-(void) showPauseButton;

@end
