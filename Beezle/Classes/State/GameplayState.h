//
//  GameplayState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"
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
@class SpawnSystem;
@class WaterWaveSystem;
@class FollowControlSystem;
@class DestructControlSystem;
@class FadeSystem;
@class SandSystem;
@class TeleportSystem;
@class SlingerControlSystem;
@class PollenSystem;
@class RespawnSystem;
@class SoundSystem;
@class DestroySystem;
@class SlingerGogglesSystem;
@class InAppLayer;

@interface GameplayState : BeezleGameState
{
	NSString *_levelName;
	LevelSession *_levelSession;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	CCMenuItemImage *_pauseMenuItem;
	InAppLayer *_inAppLayer;

	World *_world;
	
	BOOL _musicDisabled;

	SoundSystem *_soundSystem;
	BeeaterSystem *_beeaterSystem;
	CapturedSystem *_capturedSystem;
    BeeExpiratonSystem *_beeExpirationSystem;
	DestroySystem *_destroySystem;
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
	PollenSystem *_pollenSystem;
    SlingerControlSystem *_slingerControlSystem;
	AimPollenShooterSystem *_aimPollenShooterSystem;
	SlingerGogglesSystem *_slingerGogglesSystem;
	DestructControlSystem *_destructControlSystem;
	FollowControlSystem *_followControlSystem;
	SpawnSystem *_spawnSystem;
	SandSystem *_sandSystem;
	ShakeSystem *_shakeSystem;
	HealthSystem *_healthSystem;
	RespawnSystem *_respawnSystem;
	DisposalSystem *_disposalSystem;

    NSMutableArray *_modes;
    GameMode *_currentMode;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) CCLayer *uiLayer;
@property (nonatomic, readonly) InAppLayer *inAppLayer;
@property (nonatomic, readonly) World *world;
@property (nonatomic) BOOL musicDisabled;
@property (nonatomic, readonly) AimPollenShooterSystem *aimPollenShooterSystem;
@property (nonatomic, readonly) BeeaterSystem *beeaterSystem;
@property (nonatomic, readonly) BeeExpiratonSystem *beeExpirationSystem;
@property (nonatomic, readonly) BeeQueueRenderingSystem *beeQueueRenderingSystem;
@property (nonatomic, readonly) CapturedSystem *capturedSystem;
@property (nonatomic, readonly) CollisionSystem *collisionSystem;
@property (nonatomic, readonly) DestroySystem *destroySystem;
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
@property (nonatomic, readonly) PollenSystem *pollenSystem;
@property (nonatomic, readonly) RenderSystem *renderSystem;
@property (nonatomic, readonly) RespawnSystem *respawnSystem;
@property (nonatomic, readonly) SandSystem *sandSystem;
@property (nonatomic, readonly) ShakeSystem *shakeSystem;
@property (nonatomic, readonly) ShardSystem *shardSystem;
@property (nonatomic, readonly) SlingerControlSystem *slingerControlSystem;
@property (nonatomic, readonly) SlingerGogglesSystem *slingerGogglesSystem;
@property (nonatomic, readonly) SoundSystem *soundSystem;
@property (nonatomic, readonly) SpawnSystem *spawnSystem;
@property (nonatomic, readonly) TeleportSystem *teleportSystem;
@property (nonatomic, readonly) WaterWaveSystem *waterWaveSystem;

+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;
-(void) pauseGame:(id)sender;
-(void) hidePauseButton;
-(void) showPauseButton;
-(void) nextLevel;
-(void) closeAllDialogs;

@end
