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
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
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
    [_collisionSystem release];
    [_renderSystem release];
    [_slingerControlSystem release];
    [_boundrySystem release];
    
    [_label release];
	
	[super dealloc];
}

-(void) initialise
{
	SystemManager *systemManager = [_world systemManager];
	
	_physicsSystem = [[PhysicsSystem alloc] init];
	[systemManager setSystem:_physicsSystem];
	_collisionSystem = [[CollisionSystem alloc] init];
	[systemManager setSystem:_collisionSystem];
	_renderSystem = [[RenderSystem alloc] initWithLayer:_layer];
	[systemManager setSystem:_renderSystem];
	_slingerControlSystem = [[SlingerControlSystem alloc] init];
	[systemManager setSystem:_slingerControlSystem];
	_boundrySystem = [[BoundrySystem alloc] init];
	[systemManager setSystem:_boundrySystem];
    
    [systemManager initialiseAll];
    
	_interval = 10;
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

-(void) spawnEntity
{
    Entity *entity = [_world createEntity];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint randomPosition = CGPointMake(RANDOM_INT(0, (int)winSize.width), RANDOM_INT(0, (int)winSize.height));
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(randomPosition.x, randomPosition.y)] autorelease];
    [entity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[[RenderComponent alloc] initWithSpriteSheetName:@"Beeater" andFrameFormat:@"Beeater-0%i.png"] autorelease];
    [renderComponent addAnimation:@"idle" withStartFrame:1 andEndFrame:9];
    [entity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    body->p = cpv(randomPosition.x, randomPosition.y);
    int rotation = RANDOM_INT(0, 359);
    body->a = CC_DEGREES_TO_RADIANS(rotation);
    cpShape *shape = cpCircleShapeNew(body, 25, cpv(0, 0));
    shape->e = 0.5f;
    shape->u = 0.5f;
//    cpShapeSetGroup(shape, 1);
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [entity addComponent:physicsComponent];
    
    [entity refresh];
    
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    [groupManager addEntity:entity toGroup:@"ENTITIES"];
}

-(void) touchBegan:(Touch *)touch
{
	// Delete all entities when tapping the screen
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *entities = [groupManager getEntitiesInGroup:@"ENTITIES"];
    for (Entity *entity in entities)
    {
        [entity deleteEntity];
    }
}

@end
