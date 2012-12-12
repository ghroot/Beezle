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
#import "GameRulesSystem.h"
#import "ShardSystem.h"
#import "HealthSystem.h"
#import "HUDRenderingSystem.h"
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
#import "SoundManager.h"
#import "SpawnSystem.h"
#import "WaterWaveSystem.h"
#import "FollowControlSystem.h"
#import "DestructControlSystem.h"
#import "FadeSystem.h"
#import "AnythingWithVoidCollisionHandler.h"
#import "AnythingWithVolatileCollisionHandler.h"
#import "SoundSystem.h"
#import "BeeWithBeeaterCollisionHandler.h"
#import "BeeWithSpikeCollisionHandler.h"
#import "DozerWithCrumbleCollisionHandler.h"
#import "PulverizeWithPulverizableCollisionHandler.h"
#import "SawWithWoodCollisionHandler.h"
#import "SolidWithSoundCollisionHandler.h"
#import "SolidWithBoostCollisionHandler.h"
#import "SolidWithBreakableCollisionHandler.h"
#import "TeleportSystem.h"
#import "SolidWithWaterCollisionHandler.h"
#import "SolidWithWobbleCollisionHandler.h"
#import "SandSystem.h"
#import "PollenSystem.h"
#import "PausedMenuState.h"
#import "Game.h"
#import "PossessWithSpiritCollisionHandler.h"
#import "BalloonDialog.h"
#import "Utils.h"
#import "TutorialDescription.h"
#import "TutorialOrganizer.h"
#import "PlayerInformation.h"
#import "TutorialBalloonDescription.h"
#import "LevelLayoutCache.h"
#import "LevelLayout.h"
#import "NSObject+PWObject.h"
#import "BeeWithTeleportCollisionHandler.h"
#import "SlingerControlSystem.h"
#import "RespawnSystem.h"
#import "GameStateUtils.h"
#import "LevelThemeSelectMenuState.h"
#import "GameCompletedDialog.h"
#import "GameAlmostCompletedDialog.h"
#import "HiddenLevelsFoundDialog.h"
#import "CCMenuItemImageScale.h"
#import "GameCompletedLiteDialog.h"

@interface GameplayState()

-(void) createUI;
-(void) createWorldAndSystems;
-(void) registerCollisionHandlers;
-(void) createModes;
-(void) loadLevel;
-(void) checkTutorial;
-(void) enterMode:(GameMode *)mode;
-(void) updateMode:(float)delta;

@end

@implementation GameplayState

@synthesize levelName = _levelName;
@synthesize uiLayer = _uiLayer;
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
@synthesize pollenSystem = _pollenSystem;
@synthesize renderSystem = _renderSystem;
@synthesize respawnSystem = _respawnSystem;
@synthesize sandSystem = _sandSystem;
@synthesize shakeSystem = _shakeSystem;
@synthesize shardSystem = _shardSystem;
@synthesize slingerControlSystem = _slingerControlSystem;
@synthesize soundSystem = _soundSystem;
@synthesize spawnSystem = _spawnSystem;
@synthesize teleportSystem = _teleportSystem;
@synthesize waterWaveSystem = _waterWaveSystem;
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
	[self performBlock:^{
		[self checkTutorial];
	} afterDelay:0.4f];

	[[SessionTracker sharedTracker] trackStartedLevel:_levelName];
}

-(void) createUI
{
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
	_pauseMenuItem = [[CCMenuItemImageScale itemWithNormalImage:@"Syst-GamePause-White.png" selectedImage:@"Syst-GamePause-White.png" target:self selector:@selector(pauseGame:)] retain];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    [_pauseMenuItem setPosition:CGPointMake(2.0f, winSize.height - 2.0f)];
    [_pauseMenuItem setAnchorPoint:CGPointMake(0.0f, 1.0f)];
    CCMenu *menu = [CCMenu menuWithItems:_pauseMenuItem, nil];
    [menu setPosition:CGPointZero];
    [_uiLayer addChild:menu];
}

-(void) createWorldAndSystems
{	
    _world = [[World alloc] init];
    
	SystemManager *systemManager = [_world systemManager];

	_soundSystem = [SoundSystem system];
	[systemManager setSystem:_soundSystem];
    _gameRulesSystem = [[[GameRulesSystem alloc] initWithLevelSession:_levelSession] autorelease];
    [systemManager setSystem:_gameRulesSystem];
	_physicsSystem = [PhysicsSystem system];
	[systemManager setSystem:_physicsSystem];
	_movementSystem = [MovementSystem system];
	[systemManager setSystem:_movementSystem];
	_teleportSystem = [TeleportSystem system];
	[systemManager setSystem:_teleportSystem];
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
	_pollenSystem = [[[PollenSystem alloc] initWithLevelSession:_levelSession] autorelease];
	[systemManager setSystem:_pollenSystem];
	_sandSystem = [SandSystem system];
	[systemManager setSystem:_sandSystem];
	_shakeSystem = [ShakeSystem system];
	[systemManager setSystem:_shakeSystem];
	_healthSystem = [HealthSystem system];
	[systemManager setSystem:_healthSystem];
	_respawnSystem = [RespawnSystem system];
	[systemManager setSystem:_respawnSystem];
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
	[_collisionSystem registerCollisionHandler:[BeeWithTeleportCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[AnythingWithVoidCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[AnythingWithVolatileCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[BeeWithBeeaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[BeeWithSpikeCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[DozerWithCrumbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[PossessWithSpiritCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithSoundCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithBoostCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithBreakableCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithWaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SolidWithWobbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[_collisionSystem registerCollisionHandler:[SawWithWoodCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
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

-(void) checkTutorial
{
	TutorialBalloonDescription *tutorialBalloonDescription = [[TutorialOrganizer sharedOrganizer] tutorialBalloonDescriptionForLevel:_levelName];
	if (tutorialBalloonDescription != nil &&
		![[PlayerInformation sharedInformation] hasSeenTutorialId:[tutorialBalloonDescription id]])
	{
		BalloonDialog *balloonDialog = [[[BalloonDialog alloc] initWithFileName:[tutorialBalloonDescription fileName] andOffset:[tutorialBalloonDescription offset]] autorelease];
		[_uiLayer addChild:balloonDialog];

		[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialBalloonDescription id]];
	}
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_levelName release];
	[_levelSession release];
	
    [_modes release];
    
    [_world release];

	[_pauseMenuItem release];

	[super dealloc];
}

-(void) enter
{
    [super enter];
    
    [_currentMode enter];

	NSString *musicName;
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:_levelName];
	if ([levelLayout isBossLevel])
	{
		musicName = @"MusicBoss";
	}
	else
	{
		musicName = [NSString stringWithFormat:@"Music%@", [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName]];
	}
	[[SoundManager sharedManager] playMusic:musicName loop:TRUE];
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
	[self hidePauseButton];
	CCNode *screenShotNode = [Utils takeScreenShot];
	[self showPauseButton];

	[_game pushState:[[[PausedMenuState alloc] initWithBackground:screenShotNode andLevelSession:_levelSession] autorelease] transition:FALSE];
}

-(void) hidePauseButton
{
	[_pauseMenuItem setVisible:FALSE];
}

-(void) showPauseButton
{
	[_pauseMenuItem setVisible:TRUE];
}

-(void) nextLevel
{
	if ([[LevelOrganizer sharedOrganizer] isLastLevelInTheme:_levelName])
	{
		[self closeAllDialogs];

		NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName];
		NSString *nextTheme = [[LevelOrganizer sharedOrganizer] themeAfter:theme];
		if (nextTheme != nil)
		{
			if ([[PlayerInformation sharedInformation] canPlayTheme:nextTheme])
			{
				if ([[LevelOrganizer sharedOrganizer] isThemeHidden:nextTheme])
				{
					[_uiLayer addChild:[HiddenLevelsFoundDialog dialogWithGame:_game andLevelSession:_levelSession]];
				}
				else
				{
					[_game clearAndReplaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:nextTheme]];
				}
			}
			else
			{
				if ([[LevelOrganizer sharedOrganizer] isThemeHidden:nextTheme])
				{
					[_uiLayer addChild:[GameAlmostCompletedDialog dialogWithGame:_game]];
				}
				else
				{
					[_game clearAndReplaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:theme]];
				}
			}
		}
		else
		{
#ifdef LITE_VERSION
			[_uiLayer addChild:[GameCompletedLiteDialog dialogWithGame:_game]];
#else
			[_uiLayer addChild:[GameCompletedDialog dialogWithGame:_game]];
#endif
		}
	}
	else
	{
		NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:_levelName];
		[GameStateUtils replaceWithGameplayState:nextLevelName game:_game];
	}
}

-(void) closeAllDialogs
{
	for (int i = [[_uiLayer children] count] - 1; i >= 0; i--)
	{
		id child = [[_uiLayer children] objectAtIndex:i];
		if ([child isKindOfClass:[Dialog class]])
		{
			[_uiLayer removeChild:child cleanup:TRUE];
		}
	}
}

@end
