//
//  GameplayState.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayState.h"
#import "BoundrySystem.h"
#import "CocosGameContainer.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"
#import "Touch.h"

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
    [_boundrySystem release];
	
	[super dealloc];
}

-(void) initialise
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
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
	_boundrySystem = [[BoundrySystem alloc] init];
	[systemManager setSystem:_boundrySystem];
    
    [systemManager initialiseAll];
    
    [EntityFactory createBackground:_world withFileName:@"Background-01.jpg"];
    [EntityFactory createEdge:_world withSize:winSize];
    [EntityFactory createSlinger:_world withPosition:CGPointMake(100, 300)];
    [EntityFactory createRamp:_world withPosition:CGPointMake(150, 100) andRotation:0.0f];
    [EntityFactory createRamp:_world withPosition:CGPointMake(150, 140) andRotation:0.1f];
    [EntityFactory createRamp:_world withPosition:CGPointMake(150, 180) andRotation:-0.1f];
    [EntityFactory createPollen:_world withPosition:CGPointMake(250, 250)];
    [EntityFactory createPollen:_world withPosition:CGPointMake(300, 250)];
    [EntityFactory createPollen:_world withPosition:CGPointMake(350, 250)];
    [EntityFactory createPollen:_world withPosition:CGPointMake(400, 250)];
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
    [_boundrySystem process];
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
    InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_START andTouchLocation:[touch point]] autorelease];
    [_inputSystem pushInputAction:inputAction];
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
