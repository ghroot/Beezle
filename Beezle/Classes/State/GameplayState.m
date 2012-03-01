//
//  GameplayState.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayState.h"
#import "BeeaterSystem.h"
#import "ExplodeControlSystem.h"
#import "BeeQueueRenderingSystem.h"
#import "BeeExpiratonSystem.h"
#import "CollisionSystem.h"
#import "DebugNotificationTrackerSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "DisposableComponent.h"
#import "Game.h"
#import "GameRulesSystem.h"
#import "GateComponent.h"
#import "GateOpeningSystem.h"
#import "ShardSystem.h"
#import "HUDRenderingSystem.h"
#import "IngameMenuState.h"
#import "InputSystem.h"
#import "KeyComponent.h"
#import "LevelLoader.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MovementSystem.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PlayerInformation.h"
#import "RenderComponent.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "SlingerControlSystem.h"
#import "SoundManager.h"
#import "SpawnSystem.h"

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
-(void) loadNextLevel:(id)sender;

@end

@implementation GameplayState

@synthesize levelName = _levelName;

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
		[[CCDirector sharedDirector] setNeedClear:FALSE];
		
		_levelName = [levelName retain];
		_levelSession = [levelSession retain];
		
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

-(void) createUI
{
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"Pause.png" selectedImage:@"Pause.png" target:self selector:@selector(pauseGame:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [pauseMenuItem setPosition:CGPointMake(winSize.width, winSize.height)];
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
	_physicsSystem = [[[PhysicsSystem alloc] init] autorelease];
	[systemManager setSystem:_physicsSystem];
	_movementSystem = [[[MovementSystem alloc] init] autorelease];
	[systemManager setSystem:_movementSystem];
	_collisionSystem = [[[CollisionSystem alloc] initWithLevelSession:_levelSession] autorelease];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
	[systemManager setSystem:_renderSystem];
	_hudRenderingSystem = [[[HUDRenderingSystem alloc] initWithLayer:_uiLayer] autorelease];
	[systemManager setSystem:_hudRenderingSystem];
	_inputSystem = [[[InputSystem alloc] init] autorelease];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [[[SlingerControlSystem alloc] init] autorelease];
	[systemManager setSystem:_slingerControlSystem];
	_beeExpirationSystem = [[[BeeExpiratonSystem alloc] init] autorelease];
	[systemManager setSystem:_beeExpirationSystem];
	_explodeControlSystem = [[[ExplodeControlSystem alloc] init] autorelease];
	[systemManager setSystem:_explodeControlSystem];
	_beeQueueRenderingSystem = [[[BeeQueueRenderingSystem alloc] initWithZ:2] autorelease];
	[systemManager setSystem:_beeQueueRenderingSystem];
	_beeaterSystem = [[[BeeaterSystem alloc] init] autorelease];
	[systemManager setSystem:_beeaterSystem];
	_gateOpeningSystem = [[[GateOpeningSystem alloc] init] autorelease];
	[systemManager setSystem:_gateOpeningSystem];
	_shardSystem = [[[ShardSystem alloc] init] autorelease];
	[systemManager setSystem:_shardSystem];
	_spawnSystem = [[[SpawnSystem alloc] init] autorelease];
	[systemManager setSystem:_spawnSystem];
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
    _aimingMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
													 _movementSystem,
                                                     _physicsSystem,
                                                     _collisionSystem,
                                                     _renderSystem,
													 _hudRenderingSystem,
                                                     _inputSystem,
                                                     _slingerControlSystem,
													 _beeaterSystem,
													 _beeQueueRenderingSystem,
													 _spawnSystem,
													 _gameRulesSystem,
                                                     nil]];
    
    _shootingMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
													   _movementSystem,
													   _physicsSystem,
													   _collisionSystem,
													   _renderSystem,
													   _hudRenderingSystem,
													   _inputSystem,
													   _beeExpirationSystem,
													   _explodeControlSystem,
													   _beeaterSystem,
													   _gateOpeningSystem,
													   _beeQueueRenderingSystem,
													   _shardSystem,
													   _spawnSystem,
													   _gameRulesSystem,
													   nil]];
    
    _levelCompletedMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
															 _physicsSystem,
															 _collisionSystem,
															 _renderSystem,
															 _hudRenderingSystem,
															 _beeQueueRenderingSystem,
															 _spawnSystem,
															 nil]];
    
    _levelFailedMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
														  _physicsSystem,
														  _collisionSystem,
														  _renderSystem,
														  _hudRenderingSystem,
														  _beeQueueRenderingSystem,
														  _spawnSystem,
														  nil]];
    
    _currentMode = _aimingMode;
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
			[[RenderComponent getFrom:entity] playAnimation:@"Cavegate-Open-Idle"];
		}
		if ([[PlayerInformation sharedInformation] hasCollectedKeyInLevel:[_levelSession levelName]] &&
			[entity hasComponent:[KeyComponent class]])
		{
			[[DisposableComponent getFrom:entity] setIsDisposed:TRUE];
			[[PhysicsComponent getFrom:entity] disable];
			[[RenderComponent getFrom:entity] playAnimation:@"Nut-Open-Idle"];
		}
	}
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_notifications release];
	
	[_levelName release];
	[_levelSession release];
	
    [_aimingMode release];
    [_shootingMode release];
    [_levelCompletedMode release];
    [_levelFailedMode release];
    
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
	NSString *levelName = [[notification userInfo] objectForKey:@"hiddenLevelName"];
	[_game replaceState:[GameplayState stateWithLevelName:levelName andLevelSession:_levelSession] withTransition:[CCTransitionSlideInB class] duration:1.0f];
}

-(void) enter
{
    [super enter];
    
    [_currentMode enter];
	
	[[SoundManager sharedManager] playMusic:@"MusicA"];
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
    
    [_currentMode processSystems];
	if (_debug)
	{
        [_debugRenderPhysicsSystem process];
		[_debugNotificationTrackerSystem process];
	}
    
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
    if ([_gameRulesSystem isLevelCompleted])
    {
        if (_currentMode != _levelCompletedMode)
        {
            [self enterMode:_levelCompletedMode];
			
			TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
			Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
			SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
			int numberOfUnusedBees = [slingerComponent numberOfBeesInQueue];
			[_levelSession setNumberOfUnusedBees:numberOfUnusedBees];
			
			NSLog(@"Unused bees: %d", [_levelSession numberOfUnusedBees]);
			NSLog(@"Pollen: %d", [_levelSession totalNumberOfPollen]);
			NSLog(@"Previous record: %d", [[PlayerInformation sharedInformation] pollenRecord:[_levelSession levelName]]);
			
			[[PlayerInformation sharedInformation] storeAndSave:_levelSession];
			
			NSLog(@"New record: %d", [[PlayerInformation sharedInformation] pollenRecord:[_levelSession levelName]]);
			NSLog(@"Total: %d", [[PlayerInformation sharedInformation] totalNumberOfPollen]);
			
			CCMenuItemImage *levelCompleteMenuItem = [CCMenuItemImage itemWithNormalImage:@"Bubbla.png" selectedImage:@"Bubbla.png" target:self selector:@selector(loadNextLevel:)];
			CCMenu *levelCompleteMenu = [CCMenu menuWithItems:levelCompleteMenuItem, nil];
			[levelCompleteMenuItem setScale:0.25f];
			CCEaseElasticInOut *elasticScaleAction = [CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]];
			[levelCompleteMenuItem runAction:elasticScaleAction];
			[_uiLayer addChild:levelCompleteMenu];
		}
    }
    else if ([_gameRulesSystem isLevelFailed])
    {
        if (_currentMode != _levelFailedMode)
        {
            [self enterMode:_levelFailedMode];
			
			[self showLabel:@"Level Failed..."];
        }
    } 
    else if (_currentMode == _aimingMode &&
        [_gameRulesSystem isBeeFlying])
    {
        [self enterMode:_shootingMode];
    }
    else if (_currentMode == _shootingMode &&
             ![_gameRulesSystem isBeeFlying])
    {
		[self enterMode:_aimingMode];
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

-(void) loadNextLevel:(id)sender
{
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesForTheme:@"A"];
	int nextLevelIndex = [levelNames indexOfObject:[_levelSession levelName]] + 1;
	NSString *nextLevelName = [levelNames objectAtIndex:nextLevelIndex];
	if (nextLevelName != nil)
	{
		[_game replaceState:[GameplayState stateWithLevelName:nextLevelName] withTransition:[CCTransitionFade class] duration:0.3f];
	}
}

@end
