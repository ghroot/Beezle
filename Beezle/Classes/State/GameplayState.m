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
#import "Game.h"
#import "GameRulesSystem.h"
#import "GateOpeningSystem.h"
#import "GlassAnimationSystem.h"
#import "IngameMenuState.h"
#import "InputSystem.h"
#import "LevelLoader.h"
#import "LevelSession.h"
#import "MovementSystem.h"
#import "NotificationTypes.h"
#import "PhysicsSystem.h"
#import "PlayerInformation.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"
#import "SoundManager.h"
#import "TrailSystem.h"

@interface GameplayState()

-(void) createUI;
-(void) createWorldAndSystems;
-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotifications;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleGateEntered:(NSNotification *)notification;
-(void) createModes;
-(void) enterMode:(GameMode *)mode;
-(void) updateMode;
-(void) showLabel:(NSString *)labelText;

@end

@implementation GameplayState

+(id) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
    if (self = [super init])
    {
		[[CCDirector sharedDirector] setNeedClear:FALSE];
		
		_levelSession = [[LevelSession alloc] initWithLevelName:levelName];
		
		_debug = FALSE;
		
		_notifications = [NSMutableArray new];
		[self addNotificationObservers];
		
		_gameLayer = [CCLayer node];
		[self addChild:_gameLayer];
		
		[self createUI];
		[self createWorldAndSystems];
        [self createModes];
		[[LevelLoader sharedLoader] loadLevel:levelName inWorld:_world edit:FALSE];
    }
    return self;
}

-(id) init
{
	return [self initWithLevelName:nil];
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
	_glassAnimationSystem = [[[GlassAnimationSystem alloc] init] autorelease];
	[systemManager setSystem:_glassAnimationSystem];
	_trailSystem = [[[TrailSystem alloc] init] autorelease];
	[systemManager setSystem:_trailSystem];
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
													 _gameRulesSystem,
													 _movementSystem,
                                                     _physicsSystem,
                                                     _collisionSystem,
                                                     _renderSystem,
                                                     _inputSystem,
                                                     _slingerControlSystem,
													 _beeQueueRenderingSystem,
                                                     nil]];
    
    _shootingMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
													   _gameRulesSystem,
													   _movementSystem,
													   _physicsSystem,
													   _collisionSystem,
													   _renderSystem,
													   _inputSystem,
													   _beeExpirationSystem,
													   _explodeControlSystem,
													   _beeaterSystem,
													   _gateOpeningSystem,
													   _beeQueueRenderingSystem,
													   _glassAnimationSystem,
													   _trailSystem,
													   nil]];
    
    _levelCompletedMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
															 _physicsSystem,
															 _collisionSystem,
															 _renderSystem,
															 _beeQueueRenderingSystem,
															 nil]];
    
    _levelFailedMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
														  _physicsSystem,
														  _collisionSystem,
														  _renderSystem,
														  _beeQueueRenderingSystem,
														  nil]];
    
    _currentMode = _aimingMode;
}

-(void) dealloc
{	
	[_levelSession release];
	
	[_notifications release];
	
    [_aimingMode release];
    [_shootingMode release];
    [_levelCompletedMode release];
    [_levelFailedMode release];
    
    [_world release];
	
	[super dealloc];
}

-(NSString *) levelName
{
	return [_levelSession levelName];
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
	[_game replaceState:[GameplayState stateWithLevelName:levelName]];
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
			
			BOOL isRecord = [[PlayerInformation sharedInformation] isPollenRecord:_levelSession];
			if (isRecord)
			{	
				[self showLabel:@"Level Complete! (Record!)"];
			}
			else
			{	
				[self showLabel:@"Level Complete!"];
			}
			
			[[PlayerInformation sharedInformation] store:_levelSession];
			[[PlayerInformation sharedInformation] save];
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

@end
