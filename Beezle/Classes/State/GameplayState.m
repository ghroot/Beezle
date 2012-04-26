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
#import "DebugNotificationTrackerSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "DisposableComponent.h"
#import "DisposalSystem.h"
#import "EntityUtil.h"
#import "Game.h"
#import "GameRulesSystem.h"
#import "GateComponent.h"
#import "GateOpeningSystem.h"
#import "ShardSystem.h"
#import "HealthSystem.h"
#import "HUDRenderingSystem.h"
#import "IngameMenuState.h"
#import "InputSystem.h"
#import "KeyComponent.h"
#import "LevelCompletedMode.h"
#import "LevelFailedMode.h"
#import "LevelLoader.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MovementSystem.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PlayerInformation.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "ShakeSystem.h"
#import "ShootingMode.h"
#import "SlingerComponent.h"
#import "SlingerControlSystem.h"
#import "SoundManager.h"
#import "SpawnSystem.h"
#import "WaterWaveSystem.h"
#import "WoodSystem.h"

@interface GameplayState()

-(void) createUI;
-(void) createWorldAndSystems;
-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotifications;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleGateEntered:(NSNotification *)notification;
-(void) createModes;
-(void) loadLevel;
-(void) enterMode:(GameMode *)mode;
-(void) updateMode;
-(void) showLabel:(NSString *)labelText;

@end

@implementation GameplayState

@synthesize levelName = _levelName;
@synthesize world = _world;
@synthesize aimPollenShooterSystem = _aimPollenShooterSystem;
@synthesize beeaterSystem = _beeaterSystem;
@synthesize beeExpirationSystem = _beeExpirationSystem;
@synthesize beeQueueRenderingSystem = _beeQueueRenderingSystem;
@synthesize collisionSystem = _collisionSystem;
@synthesize disposalSystem = _disposalSystem;
@synthesize explodeControlSystem = _explodeControlSystem;
@synthesize gameRulesSystem = _gameRulesSystem;
@synthesize gateOpeningSystem = _gateOpeningSystem;
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

+(id) stateWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession
{
	return [[[self alloc] initWithLevelName:levelName andLevelSession:levelSession] autorelease];
}

+(id) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName andLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
    {
		_levelName = [levelName retain];
		_levelSession = [levelSession retain];
		
		_needsLoadingState = TRUE;
    }
    return self;
}

-(id) initWithLevelName:(NSString *)levelName
{
	self = [self initWithLevelName:levelName andLevelSession:[[[LevelSession alloc] initWithLevelName:levelName] autorelease]];
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
	
	_notifications = [NSMutableArray new];
	[self addNotificationObservers];
	
	_gameLayer = [CCLayer node];
	[self addChild:_gameLayer];
	
	[self createUI];
	[self createWorldAndSystems];
	[self createModes];
	[self loadLevel];
}

-(void) createUI
{
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseArrow-01.png" selectedImage:@"PauseArrow-01.png" target:self selector:@selector(pauseGame:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [pauseMenuItem setPosition:CGPointMake(2.0f, winSize.height -2.0f)];
    [pauseMenuItem setAnchorPoint:CGPointMake(0.0f, 1.0f)];
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
	_physicsSystem = [[[PhysicsSystem alloc] init] autorelease];
	[systemManager setSystem:_physicsSystem];
	_movementSystem = [[[MovementSystem alloc] init] autorelease];
	[systemManager setSystem:_movementSystem];
	_collisionSystem = [[[CollisionSystem alloc] initWithLevelSession:_levelSession] autorelease];
	[systemManager setSystem:_collisionSystem];
	_waterWaveSystem = [[WaterWaveSystem new] autorelease];
	[systemManager setSystem:_waterWaveSystem];
	_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
	[systemManager setSystem:_renderSystem];
	_hudRenderingSystem = [[[HUDRenderingSystem alloc] initWithLayer:_uiLayer] autorelease];
	[systemManager setSystem:_hudRenderingSystem];
	_inputSystem = [[[InputSystem alloc] init] autorelease];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [[[SlingerControlSystem alloc] init] autorelease];
	[systemManager setSystem:_slingerControlSystem];
	_aimPollenShooterSystem = [[AimPollenShooterSystem new] autorelease];
	[systemManager setSystem:_aimPollenShooterSystem];
	_beeExpirationSystem = [[[BeeExpiratonSystem alloc] init] autorelease];
	[systemManager setSystem:_beeExpirationSystem];
	_explodeControlSystem = [[[ExplodeControlSystem alloc] init] autorelease];
	[systemManager setSystem:_explodeControlSystem];
	_beeQueueRenderingSystem = [[[BeeQueueRenderingSystem alloc] initWithZ:3] autorelease];
	[systemManager setSystem:_beeQueueRenderingSystem];
	_beeaterSystem = [[[BeeaterSystem alloc] init] autorelease];
	[systemManager setSystem:_beeaterSystem];
	_gateOpeningSystem = [[[GateOpeningSystem alloc] initWithLevelSession:_levelSession] autorelease];
	[systemManager setSystem:_gateOpeningSystem];
	_shardSystem = [[[ShardSystem alloc] init] autorelease];
	[systemManager setSystem:_shardSystem];
	_spawnSystem = [[[SpawnSystem alloc] init] autorelease];
	[systemManager setSystem:_spawnSystem];
	_woodSystem = [[WoodSystem new] autorelease];
	[systemManager setSystem:_woodSystem];
	_shakeSystem = [[ShakeSystem new] autorelease];
	[systemManager setSystem:_shakeSystem];
	_healthSystem = [[HealthSystem new] autorelease];
	[systemManager setSystem:_healthSystem];
	_disposalSystem = [[DisposalSystem new] autorelease];
	[systemManager setSystem:_disposalSystem];
	if (_debug)
	{
		_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
		[systemManager setSystem:_debugRenderPhysicsSystem];
		_debugNotificationTrackerSystem = [[[DebugNotificationTrackerSystem alloc] init] autorelease];
		[systemManager setSystem:_debugNotificationTrackerSystem];
	}
	
	[systemManager initialiseAll];
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_GATE_ENTERED object:nil];
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
	
	for (Entity *entity in [[_world entityManager] entities])
	{
		if ([[PlayerInformation sharedInformation] hasUsedKeyInLevel:[_levelSession levelName]] &&
			[entity hasComponent:[GateComponent class]])
		{
			[[GateComponent getFrom:entity] setIsOpened:TRUE];
			RenderSprite *defaultRenderSprite = [[RenderComponent getFrom:entity] defaultRenderSprite];
			[defaultRenderSprite playAnimationLoop:@"Cavegate-Open-Idle"];
		}
		if ([[PlayerInformation sharedInformation] hasCollectedKeyInLevel:[_levelSession levelName]] &&
			[entity hasComponent:[KeyComponent class]])
		{
			[EntityUtil setEntityDisposed:entity sendNotification:FALSE];
			[EntityUtil disablePhysics:entity];
			RenderSprite *defaultRenderSprite = [[RenderComponent getFrom:entity] defaultRenderSprite];
			[defaultRenderSprite playAnimationLoop:@"Nut-Open-Idle"];
		}
	}
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_notifications release];
	
	[_levelName release];
	[_levelSession release];
	
    [_modes release];
    
    [_world release];
	
	[super dealloc];
}

-(void) queueNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(void) handleNotifications
{
	while ([_notifications count] > 0)
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self handleNotification:nextNotification];
		[nextNotification release];
	}
}

-(void) handleNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_GATE_ENTERED])
	{
		[self handleGateEntered:notification];
	}
}

-(void) handleGateEntered:(NSNotification *)notification
{
	NSString *caveLevelName = [NSString stringWithFormat:@"%@%@", [_levelSession levelName], @"-Cave", nil];
	[_game replaceState:[GameplayState stateWithLevelName:caveLevelName andLevelSession:_levelSession]];
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
	[_world setDelta:(1000.0f * delta)];
    
    [self updateMode];
	
	[self handleNotifications];
}

-(void) enterMode:(GameMode *)mode
{
    [_currentMode leave];
    _currentMode = mode;
    [_currentMode enter];
}

-(void) updateMode
{
	[_currentMode update];
	
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

-(void) showLabel:(NSString *)labelText
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCLabelTTF *label = [CCLabelTTF labelWithString:labelText fontName:@"Courier" fontSize:30];
	[label setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
	[_uiLayer addChild:label];
}

@end
