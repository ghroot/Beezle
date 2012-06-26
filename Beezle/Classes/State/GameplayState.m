//
//  GameplayState.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayState.h"
#import "AimingMode.h"
#import "AimPollenShooterSystem.h"
#import "BeeaterSystem.h"
#import "ExplodeControlSystem.h"
#import "BeeQueueRenderingSystem.h"
#import "BeeExpiratonSystem.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "DisposalSystem.h"
#import "CapturedSystem.h"
#import "FreezeSystem.h"
#import "Game.h"
#import "GameRulesSystem.h"
#import "ShardSystem.h"
#import "HealthSystem.h"
#import "HUDRenderingSystem.h"
#import "IngameMenuState.h"
#import "InputSystem.h"
#import "LevelCompletedMode.h"
#import "LevelFailedMode.h"
#import "LevelLoader.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MovementSystem.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SessionTracker.h"
#import "ShakeSystem.h"
#import "ShootingMode.h"
#import "SlingerControlSystem.h"
#import "SoundManager.h"
#import "SpawnSystem.h"
#import "WaterWaveSystem.h"
#import "WoodSystem.h"
#import "FollowControlSystem.h"
#import "DestructControlSystem.h"
#import "FadeSystem.h"
#import "AnythingWithVoidCollisionHandler.h"
#import "AnythingWithVolatileCollisionHandler.h"
#import "BeeWithBeeaterCollisionHandler.h"
#import "BeeWithSpikeCollisionHandler.h"
#import "ConsumerWithPollenCollisionHandler.h"
#import "DozerWithCrumbleCollisionHandler.h"
#import "PulverizeWithPulverizableCollisionHandler.h"
#import "SawWithWoodCollisionHandler.h"
#import "SolidWithSoundCollisionHandler.h"
#import "SolidWithBoostCollisionHandler.h"
#import "SolidWithBreakableCollisionHandler.h"
#import "SolidWithWaterCollisionHandler.h"
#import "SolidWithWobbleCollisionHandler.h"

@interface GameplayState()

-(void) createUI;
-(void) createWorldAndSystems;
-(void) registerCollisionHandlers;
-(void) createModes;
-(void) loadLevel;
-(void) enterMode:(GameMode *)mode;
-(void) updateMode:(float)delta;

@end

@implementation GameplayState

@synthesize levelName = _levelName;
@synthesize world = _world;
@synthesize aimPollenShooterSystem = _aimPollenShooterSystem;
@synthesize beeaterSystem = _beeaterSystem;
@synthesize beeExpirationSystem = _beeExpirationSystem;
@synthesize beeQueueRenderingSystem = _beeQueueRenderingSystem;
@synthesize capturedSystem = _capturedSystem;
@synthesize collisionSystem = _collisionSystem;
@synthesize destructControlSystem = _destructControlSystem;
@synthesize disposalSystem = _disposalSystem;
@synthesize explodeControlSystem = _explodeControlSystem;
@synthesize fadeSystem = _fadeSystem;
@synthesize freezeSystem = _freezeSystem;
@synthesize gameRulesSystem = _gameRulesSystem;
@synthesize healthSystem = _healthSystem;
@synthesize hudRenderingSystem = _hudRenderingSystem;
@synthesize inputSystem = _inputSystem;
@synthesize movementSystem = _movementSystem;
@synthesize physicsSystem = _physicsSystem;
@synthesize renderSystem = _renderSystem;
@synthesize shakeSystem = _shakeSystem;
@synthesize shardSystem = _shardSystem;
@synthesize slingerControlSystem = _slingerControlSystem;
@synthesize spawnSystem = _spawnSystem;
@synthesize waterWaveSystem = _waterWaveSystem;
@synthesize woodSystem = _woodSystem;
@synthesize followControlSystem = _followControlSystem;


+(id) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
    {
		_levelName = [levelName retain];
		_levelSession = [[LevelSession alloc] initWithLevelName:levelName];
		
		_needsLoadingState = TRUE;
    }
    return self;
}

-(id) init
{
	self = [self initWithLevelName:nil];
	return self;
}

-(void) initialise
{
	[super initialise];
	
	_debug = FALSE;
	
	_gameLayer = [CCLayer node];
	[self addChild:_gameLayer];
	
	[self createUI];
	[self createWorldAndSystems];
	[self registerCollisionHandlers];
	[self createModes];
	[self loadLevel];

	// TEMP: Particle overlays
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName];
	if ([_levelName isEqualToString:[NSString stringWithFormat:@"Level-%@17", theme]])
	{
		if ([theme isEqualToString:@"A"])
		{
			[_uiLayer addChild:[CCParticleSystemQuad particleWithFile:@"Rain-Particle.plist"]];
		}
		else if ([theme isEqualToString:@"B"])
		{
			[_uiLayer addChild:[CCParticleSystemQuad particleWithFile:@"Lava-Particle.plist"]];
		}
		else if ([theme isEqualToString:@"C"])
		{
			[_uiLayer addChild:[CCParticleSystemQuad particleWithFile:@"Snow-Particle.plist"]];
		}
		else if ([theme isEqualToString:@"D"])
		{
			[_uiLayer addChild:[CCParticleSystemQuad particleWithFile:@"Sand-Particle.plist"]];
		}
	}
	
	[[SessionTracker sharedTracker] trackStartedLevel:_levelName];
}

-(void) createUI
{
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseArrow-01.png" selectedImage:@"PauseArrow-01.png" target:self selector:@selector(pauseGame:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [pauseMenuItem setPosition:CGPointMake(winSize.width - 2.0f, winSize.height - 2.0f)];
    [pauseMenuItem setAnchorPoint:CGPointMake(1.0f, 1.0f)];
    CCMenu *menu = [CCMenu menuWithItems:pauseMenuItem, nil];
    [menu setPosition:CGPointZero];
    [_uiLayer addChild:menu];
}

-(void) createWorldAndSystems
{	
    _world = [[World alloc] init];
    
	SystemManager *systemManager = [_world systemManager];
	
    _gameRulesSystem = [[[GameRulesSystem alloc] initWithLevelSession:_levelSession] autorelease];
    [systemManager setSystem:_gameRulesSystem];
	_physicsSystem = [PhysicsSystem system];
	[systemManager setSystem:_physicsSystem];
	_movementSystem = [MovementSystem system];
	[systemManager setSystem:_movementSystem];
	_collisionSystem = [[[CollisionSystem alloc] initWithLevelSession:_levelSession] autorelease];
	[systemManager setSystem:_collisionSystem];
	_waterWaveSystem = [WaterWaveSystem system];
	[systemManager setSystem:_waterWaveSystem];
	_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
	[systemManager setSystem:_renderSystem];
	_hudRenderingSystem = [[[HUDRenderingSystem alloc] initWithLayer:_uiLayer] autorelease];
	[systemManager setSystem:_hudRenderingSystem];
	_inputSystem = [InputSystem system];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [SlingerControlSystem system];
	[systemManager setSystem:_slingerControlSystem];
	_aimPollenShooterSystem = [AimPollenShooterSystem system];
	[systemManager setSystem:_aimPollenShooterSystem];
	_destructControlSystem = [DestructControlSystem system];
	[systemManager setSystem:_destructControlSystem];
	_followControlSystem = [FollowControlSystem system];
	[systemManager setSystem:_followControlSystem];
	_freezeSystem = [FreezeSystem system];
	[systemManager setSystem:_freezeSystem];
	_fadeSystem = [FadeSystem system];
	[systemManager setSystem:_fadeSystem];
	_beeExpirationSystem = [BeeExpiratonSystem system];
	[systemManager setSystem:_beeExpirationSystem];
	_explodeControlSystem = [ExplodeControlSystem system];
	[systemManager setSystem:_explodeControlSystem];
	_beeQueueRenderingSystem = [BeeQueueRenderingSystem system];
	[systemManager setSystem:_beeQueueRenderingSystem];
	_beeaterSystem = [BeeaterSystem system];
	[systemManager setSystem:_beeaterSystem];
	_capturedSystem = [CapturedSystem system];
	[systemManager setSystem:_capturedSystem];
	_shardSystem = [ShardSystem system];
	[systemManager setSystem:_shardSystem];
	_spawnSystem = [SpawnSystem system];
	[systemManager setSystem:_spawnSystem];
	_woodSystem = [WoodSystem system];
	[systemManager setSystem:_woodSystem];
	_shakeSystem = [ShakeSystem system];
	[systemManager setSystem:_shakeSystem];
	_healthSystem = [HealthSystem system];
	[systemManager setSystem:_healthSystem];
	_disposalSystem = [DisposalSystem system];
	[systemManager setSystem:_disposalSystem];
	if (_debug)
	{
		_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
		[systemManager setSystem:_debugRenderPhysicsSystem];
	}
	
	[systemManager initialiseAll];
}

-(void) registerCollisionHandlers
{
	[_collisionSystem registerCollisionHandler:[PulverizeWithPulverizableCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[AnythingWithVoidCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[AnythingWithVolatileCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[BeeWithBeeaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[BeeWithSpikeCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[ConsumerWithPollenCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[DozerWithCrumbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SawWithWoodCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithSoundCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithBoostCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithBreakableCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithWaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithWobbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
}

-(void) createModes
{
    _modes = [NSMutableArray new];
    
	AimingMode *aimingMode = [[[AimingMode alloc] initWithGameplayState:self] autorelease];
	ShootingMode *shootingMode = [[[ShootingMode alloc] initWithGameplayState:self] autorelease];
	LevelCompletedMode *levelCompletedMode = [[[LevelCompletedMode alloc] initWithGameplayState:self andUiLayer:_uiLayer levelSession:_levelSession] autorelease];
	LevelFailedMode *levelFailedMode = [[[LevelFailedMode alloc] initWithGameplayState:self andUiLayer:_uiLayer levelSession:_levelSession] autorelease];
	
	// Inject dependencies
	[aimingMode setShootingMode:shootingMode];
	[shootingMode setAimingMode:aimingMode];
	[shootingMode setLevelCompletedMode:levelCompletedMode];
	[shootingMode setLevelFailedMode:levelFailedMode];
	
    [_modes addObject:aimingMode];
    [_modes addObject:shootingMode];
	[_modes addObject:levelCompletedMode];
	[_modes addObject:levelFailedMode];
	
    _currentMode = aimingMode;
}

-(void) loadLevel
{
	[[LevelLoader sharedLoader] loadLevel:_levelName inWorld:_world edit:FALSE];
}

-(void) dealloc
{	
	[_levelName release];
	[_levelSession release];
	
    [_modes release];
    
    [_world release];

	[super dealloc];
}

-(void) enter
{
    [super enter];
    
    [_currentMode enter];
	
	NSString *musicName = [NSString stringWithFormat:@"Music%@", [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName]];
	[[SoundManager sharedManager] playMusic:musicName loop:FALSE];
}

-(void) leave
{
	[[SoundManager sharedManager] stopMusic];
	
    [_currentMode leave];
    
    [super leave];
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(int)(1000.0f * delta)];
    
    [self updateMode:delta];
}

-(void) enterMode:(GameMode *)mode
{
    [_currentMode leave];
    _currentMode = mode;
    [_currentMode enter];
}

-(void) updateMode:(float)delta
{
	[_currentMode update:delta];
	
	GameMode *nextMode = [_currentMode nextMode];
	if (nextMode != nil)
	{
		[self enterMode:nextMode];
	}
}

-(void) pauseGame:(id)sender
{
	[_game pushState:[IngameMenuState state]];
}

@end
