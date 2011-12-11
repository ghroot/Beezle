//
//  GameplayState.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayState.h"
#import "BeeSystem.h"
#import "BeeTypes.h"
#import "BoundrySystem.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "Game.h"
#import "GameRulesSystem.h"
#import "IngameMenuState.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SimpleAudioEngine.h"
#import "SlingerControlSystem.h"

@interface GameplayState()

-(void) createUI;
-(void) updateRenderSpritesFromBees;
-(void) createWorldAndSystems;
-(void) createModes;
-(void) preloadSounds;
-(void) loadLevel:(NSString *)levelName;
-(void) enterMode:(GameMode *)mode;
-(void) updateMode;

@end

@implementation GameplayState

@synthesize levelName = _levelName;

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
		
		[[CCDirector sharedDirector] setNeedClear:FALSE];
		
		_debug = FALSE;
		
        [self createUI];
		[self createWorldAndSystems];
        [self createModes];
		[self preloadSounds];
		[self loadLevel:_levelName];
    }
    return self;
}

-(id) init
{
	return [self initWithLevelName:nil];
}

-(void) createUI
{
    _gameLayer = [CCLayer node];
    [self addChild:_gameLayer];
    
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"Pause.png" selectedImage:@"Pause.png" target:self selector:@selector(pauseGame:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [pauseMenuItem setPosition:CGPointMake(winSize.width, winSize.height)];
    [pauseMenuItem setAnchorPoint:CGPointMake(1.0f, 1.0f)];
    CCMenu *menu = [CCMenu menuWithItems:pauseMenuItem, nil];
    [menu setPosition:CGPointZero];
    [_uiLayer addChild:menu];
    
    _beeQueueSprites = [[NSMutableArray alloc] init];
}

-(void) updateRenderSpritesFromBees
{
    for (CCSprite *sprite in _beeQueueSprites)
    {
        [_uiLayer removeChild:sprite cleanup:TRUE];
    }
    [_beeQueueSprites removeAllObjects];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int startX = 60;
    int currentX = startX;
    int currentY = winSize.height - 15;
    int spacing = 5;
    for (BeeTypes *beeType in [_gameRulesSystem beeQueue])
    {
        NSString *frameName = [NSString stringWithFormat:@"%@/%@-01.png", [beeType capitalizedString], [beeType capitalizedString]];        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        CCSprite *beeQueueSprite = [CCSprite spriteWithFile:@"Sprites.png" rect:[frame rect]];
        [beeQueueSprite setPosition:CGPointMake(currentX, currentY)];
        [_beeQueueSprites addObject:beeQueueSprite];
        [_uiLayer addChild:beeQueueSprite];
        
        currentX -= [beeQueueSprite contentSize].width + spacing;
    }
}

-(void) createWorldAndSystems
{
	[_levelName release];
	
    _world = [[World alloc] init];
    
	SystemManager *systemManager = [_world systemManager];
	
    _gameRulesSystem = [[[GameRulesSystem alloc] init] autorelease];
    [systemManager setSystem:_gameRulesSystem];
	_physicsSystem = [[[PhysicsSystem alloc] init] autorelease];
	[systemManager setSystem:_physicsSystem];
	_collisionSystem = [[[CollisionSystem alloc] init] autorelease];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
	[systemManager setSystem:_renderSystem];
	if (_debug)
	{
		_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
		[systemManager setSystem:_debugRenderPhysicsSystem];
	}
	_inputSystem = [[[InputSystem alloc] init] autorelease];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [[[SlingerControlSystem alloc] init] autorelease];
	[systemManager setSystem:_slingerControlSystem];
	_beeSystem = [[[BeeSystem alloc] init] autorelease];
	[systemManager setSystem:_beeSystem];
	
	[systemManager initialiseAll];
}

-(void) createModes
{
    _aimingMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
                                                     _gameRulesSystem,
                                                     _physicsSystem,
                                                     _collisionSystem,
                                                     _renderSystem,
                                                     _inputSystem,
                                                     _slingerControlSystem,
                                                     nil]];
    
    _shootingMode = [[GameMode alloc] initWithSystems:[NSArray arrayWithObjects:
                                               _gameRulesSystem,
                                               _physicsSystem,
                                               _collisionSystem,
                                               _renderSystem,
                                               _beeSystem,
                                               nil]];
    
    _levelCompletedMode = [[GameMode alloc] init];
    
    _levelFailedMode = [[GameMode alloc] init];
    
    _currentMode = _aimingMode;
}

-(void) dealloc
{
    [_beeQueueSprites release];
    
    [_aimingMode release];
    [_shootingMode release];
    [_levelCompletedMode release];
    [_levelFailedMode release];
    
    [_world release];
	
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
            NSMutableArray *beeTypes = [NSMutableArray array];
            for (NSString *beeTypeAsString in [levelLayoutEntry beeTypesAsStrings])
            {
                BeeTypes *beeType = [BeeTypes beeTypeFromString:beeTypeAsString];
                [beeTypes addObject:beeType];
            }
            
            [EntityFactory createSlinger:_world withPosition:[levelLayoutEntry position] beeTypes:beeTypes];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            BeeTypes *beeType = [BeeTypes beeTypeFromString:[levelLayoutEntry beeTypeAsString]];
            [EntityFactory createBeeater:_world withPosition:[levelLayoutEntry position] mirrored:[levelLayoutEntry mirrored] beeType:beeType];
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
        else if ([[levelLayoutEntry type] isEqualToString:@"NUT"])
        {
            [EntityFactory createNut:_world withPosition:[levelLayoutEntry position]];
        }
    }
}

-(void) enter
{
    [super enter];
    
    [_currentMode enter];
}

-(void) leave
{
    [_currentMode leave];
    
    [super leave];
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(1000.0f * delta)];
    
    [_currentMode processSystems];
    
    [self updateRenderSpritesFromBees];
    
    [self updateMode];
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
        }
    }
    else if ([_gameRulesSystem isLevelFailed])
    {
        if (_currentMode != _levelFailedMode)
        {
            [self enterMode:_levelFailedMode];
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

-(void) draw
{
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
