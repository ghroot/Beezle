//
//  TestState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestState.h"
#import "Beezle.h"
#import "BoundrySystem.h"
#import "CocosGameContainer.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "ForwardLayer.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"
#import "Touch.h"
#import "TransformComponent.h"

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@interface TestState()

-(void) spawnEntity;

@end

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
    [_renderSystem release];
    
    [_label release];
	
	[super dealloc];
}

-(void) initialise
{
    [[CCDirector sharedDirector] setNeedClear:TRUE];
    
	SystemManager *systemManager = [_world systemManager];
	
	_physicsSystem = [[PhysicsSystem alloc] init];
	[systemManager setSystem:_physicsSystem];
	_renderSystem = [[RenderSystem alloc] initWithLayer:_layer];
	[systemManager setSystem:_renderSystem];
    _debugRenderPhysicsSystem = [[DebugRenderPhysicsSystem alloc] init];
    [systemManager setSystem:_debugRenderPhysicsSystem];
    
    [systemManager initialiseAll];
    
	_interval = 5;
    _countdown = _interval;
	
    [_label setPosition:CGPointMake(15, 310)];
    [_layer addChild:_label];
}

-(void) update:(int)delta
{
	[_world loopStart];
	[_world setDelta:delta];
	
    [[_world systemManager] processAll];
	
	_countdown--;
    if (_countdown == 0)
    {
        [self spawnEntity];
        _countdown = _interval;
    }
    
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *entities = [groupManager getEntitiesInGroup:@"ENTITIES"];
    [_label setString:[NSString stringWithFormat:@"%i", [entities count]]];
}

-(void) render
{
    [_debugRenderPhysicsSystem process];
}

-(void) spawnEntity
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint randomPosition = CGPointMake(RANDOM_INT(0, (int)winSize.width), RANDOM_INT(0, (int)winSize.height));
    
    Entity *entity = [EntityFactory createPollen:_world withPosition:randomPosition];
    
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    [groupManager addEntity:entity toGroup:@"ENTITIES"];
}

-(void) touchBegan:(Touch *)touch
{
	// TEMP: Go to main menu by touching top left corner
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	if ([touch point].x <= 20 && [touch point].y >= winSize.height - 20)
	{
		[_game enterState:STATE_MAIN_MENU];
	}
	else
	{
		// Delete all entities when tapping the screen
		GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
		NSArray *entities = [groupManager getEntitiesInGroup:@"ENTITIES"];
		for (Entity *entity in entities)
		{
			[entity deleteEntity];
		}
	}
}

@end
