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
#import "InputSystem.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"

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

-(void) initialiseWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
	SystemManager *systemManager = [_world systemManager];
	CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
	
	_physicsSystem = [[PhysicsSystem alloc] init];
	[systemManager setSystem:_physicsSystem];
	_collisionSystem = [[CollisionSystem alloc] init];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[RenderSystem alloc] initWithLayer:layer];
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
}

-(void) updateWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game delta:(int)delta
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

-(void) renderWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
	if (_debug)
	{
		[_debugRenderPhysicsSystem process];
	}
}

@end
