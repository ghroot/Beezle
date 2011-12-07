//
//  TestState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestState.h"
#import "Game.h"
#import "BoundrySystem.h"
#import "CollisionSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "EntityFactory.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "MainMenuState.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerControlSystem.h"
#import "TransformComponent.h"

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@interface TestState()

-(void) spawnEntity;
-(void) deleteAllEntities;

@end

@implementation TestState

-(id) init
{
    if (self = [super init])
    {
		_layer = [[CCLayer alloc] init];
		[self addChild:_layer];
		
		_world = [[World alloc] init];
		
		SystemManager *systemManager = [_world systemManager];
	
		_physicsSystem = [[PhysicsSystem alloc] init];
		[systemManager setSystem:_physicsSystem];
		_renderSystem = [[RenderSystem alloc] initWithLayer:_layer];
		[systemManager setSystem:_renderSystem];
		_debugRenderPhysicsSystem = [[DebugRenderPhysicsSystem alloc] init];
		[systemManager setSystem:_debugRenderPhysicsSystem];
    
		[systemManager initialiseAll];
	
        _label = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Arial" fontSize:20];
		[_label setPosition:CGPointMake(15, 310)];
		[_layer addChild:_label];
		
		_interval = 5;
		_countdown = _interval;
    }
    return self;
}

-(void) dealloc
{
	[_world release];
	
    [_physicsSystem release];
    [_renderSystem release];
	[_debugRenderPhysicsSystem release];
    
    [_label release];
	[_layer release];
	
	[super dealloc];
}

-(void) update:(ccTime)delta
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

-(void) draw
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

-(void) deleteAllEntities
{
	GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	NSArray *entities = [groupManager getEntitiesInGroup:@"ENTITIES"];
	for (Entity *entity in entities)
	{
		[entity deleteEntity];
	}
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	if (convertedLocation.x <= 20 && convertedLocation.y >= winSize.height - 20)
	{
		[_game replaceState:[MainMenuState state]];
	}
	else
	{
		[self deleteAllEntities];
	}
	
	return TRUE;
}

-(void) touchBegan:(Touch *)touch
{

}

@end
