//
//  GameplayState.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayState.h"
#import "BeeSystem.h"
#import "BoundrySystem.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "Game.h"
#import "IngameMenuState.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "RenderTrajectorySystem.h"
#import "SimpleAudioEngine.h"
#import "SlingerControlSystem.h"

@interface GameplayState()

-(void) createSystems;
-(void) preloadSounds;
-(void) loadLevel:(NSString *)levelName;

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
		
		_debug = FALSE;
		
		_gameLayer = [[CCLayer alloc] init];
		[self addChild:_gameLayer];
		
		_uiLayer = [[CCLayer alloc] init];
		[self addChild:_uiLayer];
		
		CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"Pause.png" selectedImage:@"Pause.png" target:self selector:@selector(pauseGame:)];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [pauseMenuItem setPosition:CGPointMake(0.0f, winSize.height)];
        [pauseMenuItem setAnchorPoint:CGPointMake(0.0f, 1.0f)];
        CCMenu *menu = [CCMenu menuWithItems:pauseMenuItem, nil];
        [menu setPosition:CGPointZero];
		[_uiLayer addChild:menu];
		
		_world = [[World alloc] init];
		
		[self createSystems];
		
		[self preloadSounds];
		
		[self loadLevel:levelName];
    }
    return self;
}

-(id) init
{
	return [self initWithLevelName:nil];
}

-(void) createSystems
{
	SystemManager *systemManager = [_world systemManager];
	
	_physicsSystem = [[PhysicsSystem alloc] init];
	[systemManager setSystem:_physicsSystem];
	_collisionSystem = [[CollisionSystem alloc] init];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[RenderSystem alloc] initWithLayer:_gameLayer];
	[systemManager setSystem:_renderSystem];
	if (_debug)
	{
		_debugRenderPhysicsSystem = [[DebugRenderPhysicsSystem alloc] initWithScene:self];
		[systemManager setSystem:_debugRenderPhysicsSystem];
	}
	_renderTrajectorySystem = [[RenderTrajectorySystem alloc] initWithScene:self];
	[systemManager setSystem:_renderTrajectorySystem];
	_inputSystem = [[InputSystem alloc] init];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [[SlingerControlSystem alloc] init];
	[systemManager setSystem:_slingerControlSystem];
	_beeSystem = [[BeeSystem alloc] init];
	[systemManager setSystem:_beeSystem];
	
	[systemManager initialiseAll];
}

-(void) dealloc
{
	[_gameLayer release];
	[_uiLayer release];

	[_world release];
	
    [_physicsSystem release];
    [_collisionSystem release];
    [_renderSystem release];
	if (_debug)
	{
		[_debugRenderPhysicsSystem release];
	}
	[_renderTrajectorySystem release];
    [_inputSystem release];
    [_slingerControlSystem release];
    [_beeSystem release];
	
	[super dealloc];
}

-(void) preloadSounds
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"11097__a43__a43-blipp.aif"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"27134__zippi1__fart1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"52144__blaukreuz__imp-02.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"33369__herbertboland__mouthpop.wav"];
}

-(void) loadLevel:(NSString *)levelName
{
    [EntityFactory createBackground:_world withLevelName:levelName];
    [EntityFactory createEdge:_world];
    
    NSString *layoutFile = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
    [[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutsWithFile:layoutFile];
    LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
        if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
        {
            [EntityFactory createSlinger:_world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            [EntityFactory createBeeater:_world withPosition:[levelLayoutEntry position] mirrored:[levelLayoutEntry mirrored]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"RAMP"])
        {
            [EntityFactory createRamp:_world withPosition:[levelLayoutEntry position] andRotation:[levelLayoutEntry rotation]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"POLLEN"])
        {
            [EntityFactory createPollen:_world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"MUSHROOM"])
        {
            [EntityFactory createMushroom:_world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"WOOD"])
        {
            [EntityFactory createWood:_world withPosition:[levelLayoutEntry position]];
        }
    }
}

-(void) enter
{
    [super enter];
    
    // This should maybe be done inside InputSystem, but we want to make sure it is removed properly
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:_inputSystem priority:0 swallowsTouches:TRUE];
}

-(void) leave
{
    // This should maybe be done inside InputSystem, but we want to make sure it is removed properly
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:_inputSystem];
    
    [super leave];
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(1000.0f * delta)];
	
    [_physicsSystem process];
    [_collisionSystem process];
    [_renderSystem process];
    [_inputSystem process];
    [_slingerControlSystem process];
    [_beeSystem process];
}

-(void) draw
{
	[_renderTrajectorySystem process];
	if (_debug)
	{
		[_debugRenderPhysicsSystem process];
	}
}

-(void) pauseGame:(id)sender
{
	[_game pushState:[IngameMenuState state]];
}

@end
