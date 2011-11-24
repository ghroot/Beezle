//
//  TestState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestState.h"
#import "BoundrySystem.h"
#import "CocosGameContainer.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "ForwardLayer.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"
#import "TestEntitySpawningSystem.h"
#import "Touch.h"

@implementation TestState

-(id) initWithId:(int)gameStateId
{
    if (self = [super initWithId:gameStateId])
    {
		_world = [[World alloc] init];
        _label = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Arial" fontSize:20];
    }
    return self;
}

-(void) dealloc
{
	[_world release];
	
    [_physicsSystem release];
    [_collisionSystem release];
    [_renderSystem release];
    [_slingerControlSystem release];
    [_boundrySystem release];
    [_testEntitySpawningSystem release];
    
    [_label release];
	
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
	_slingerControlSystem = [[SlingerControlSystem alloc] init];
	[systemManager setSystem:_slingerControlSystem];
	_boundrySystem = [[BoundrySystem alloc] init];
	[systemManager setSystem:_boundrySystem];
    _testEntitySpawningSystem = [[TestEntitySpawningSystem alloc] init];
    [systemManager setSystem:_testEntitySpawningSystem];
    
    [systemManager initialiseAll];
    
    [_label setPosition:CGPointMake(15, 310)];
}

-(void) enterWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
    
    [layer addChild:_label];
}

-(void) updateWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game delta:(int)delta
{
	[_world loopStart];
	[_world setDelta:delta];
	
    [[_world systemManager] processAll];
    
    NSArray *entities = [[_world groupManager] getEntitiesInGroup:@"ENTITIES"];
    [_label setString:[NSString stringWithFormat:@"%i", [entities count]]];
}

-(void) leaveWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
    
    [layer removeChild:_label cleanup:TRUE];
}

-(void) touchBeganWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game touch:(Touch *)touch
{
    NSArray *entities = [[_world groupManager] getEntitiesInGroup:@"ENTITIES"];
    for (Entity *entity in entities)
    {
        [entity deleteEntity];
    }
}

@end
