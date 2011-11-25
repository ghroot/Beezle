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
    
    [systemManager initialiseAll];
    
	_interval = 10;
    _countdown = _interval;
	
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
	
	_countdown--;
    if (_countdown == 0)
    {
        [self spawnEntity];
        _countdown = _interval;
    }
    
    NSArray *entities = [[_world groupManager] getEntitiesInGroup:@"ENTITIES"];
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
    
    [entity addToGroup:@"ENTITIES"];
}

-(void) leaveWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)container;
	CCLayer *layer = [cocosGameContainer layer];
    
    [layer removeChild:_label cleanup:TRUE];
}

-(void) touchBeganWithContainer:(GameContainer *)container andGame:(StateBasedGame *)game touch:(Touch *)touch
{
	// Delete all entities when tapping the screen
    NSArray *entities = [[_world groupManager] getEntitiesInGroup:@"ENTITIES"];
    for (Entity *entity in entities)
    {
        [entity deleteEntity];
    }
}

@end
