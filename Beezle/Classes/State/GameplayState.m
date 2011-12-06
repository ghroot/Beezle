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
#import "CocosGameContainer.h"
#import "CocosStateBasedGame.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SimpleAudioEngine.h"
#import "SlingerControlSystem.h"
#import "Touch.h"

@interface GameplayState()

-(void) createSystems;
-(void) preloadSounds;
-(void) loadLevel:(NSString *)levelName;

@end

@implementation GameplayState

-(id) initWithId:(int)gameStateId
{
    if (self = [super initWithId:gameStateId])
    {
		_debug = TRUE;
		_world = [[World alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_world release];
	
    [_physicsSystem release];
    [_collisionSystem release];
    [_renderSystem release];
	if (_debug)
	{
		[_debugRenderPhysicsSystem release];
	}
    [_inputSystem release];
    [_slingerControlSystem release];
    [_beeSystem release];
	
	[super dealloc];
}

-(void) initialise
{
    [self createSystems];
    [self preloadSounds];
    [self loadLevel:@"Level-A5"];
}

-(void) createSystems
{
	SystemManager *systemManager = [_world systemManager];
	
	_physicsSystem = [[PhysicsSystem alloc] init];
	[systemManager setSystem:_physicsSystem];
	_collisionSystem = [[CollisionSystem alloc] init];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[RenderSystem alloc] initWithLayer:_layer];
	[systemManager setSystem:_renderSystem];
	if (_debug)
	{
		_debugRenderPhysicsSystem = [[DebugRenderPhysicsSystem alloc] init];
		[systemManager setSystem:_debugRenderPhysicsSystem];
	}
	_inputSystem = [[InputSystem alloc] init];
	[systemManager setSystem:_inputSystem];
	_slingerControlSystem = [[SlingerControlSystem alloc] init];
	[systemManager setSystem:_slingerControlSystem];
    _beeSystem = [[BeeSystem alloc] init];
    [systemManager setSystem:_beeSystem];
    
    [systemManager initialiseAll];
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
//            [EntityFactory createMushroom:_world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"WOOD"])
        {
            [EntityFactory createWood:_world withPosition:[levelLayoutEntry position]];
        }
    }
}

-(void) update:(int)delta
{
	[_world loopStart];
	[_world setDelta:delta];
	
    [_physicsSystem process];
    [_collisionSystem process];
    [_renderSystem process];
    [_inputSystem process];
    [_slingerControlSystem process];
    [_beeSystem process];
}

-(void) render
{
	if (_debug)
	{
		[_debugRenderPhysicsSystem process];
	}
}

-(void) touchBegan:(Touch *)touch
{
	// TEMP: Go to ingame menu by touching top left corner
	CCSize winSize = [[CCDirector sharedDirector] winSize];
	if ([touch point].x <= 20 && [touch point].y >= winSize.height - 20)
	{
		CocosStateBasedGame *cocosStateBasedGame = (CocosStateBasedGame *)[self game];
		[cocosStateBasedGame enterStateKeepCurrent:STATE_INGAME_MENU];
	}
	else
	{
		InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_START andTouchLocation:[touch point]] autorelease];
		[_inputSystem pushInputAction:inputAction];
	}
}

-(void) touchMoved:(Touch *)touch
{
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_MOVE andTouchLocation:[touch point]] autorelease];
    [_inputSystem pushInputAction:inputAction];
}

-(void) touchEnded:(Touch *)touch
{
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_END andTouchLocation:[touch point]] autorelease];
    [_inputSystem pushInputAction:inputAction];
}

@end
