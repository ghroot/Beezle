//
//  TestEntitySpawningSystem.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestEntitySpawningSystem.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "TransformComponent.h"
#import "RenderComponent.h"

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@interface TestEntitySpawningSystem()

-(void) spawnEntity;

@end

@implementation TestEntitySpawningSystem

-(void) initialise
{
    _interval = 10;
    _countdown = _interval;
}

-(void) process
{
    _countdown--;
    if (_countdown == 0)
    {
        [self spawnEntity];
        _countdown = _interval;
    }
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

@end
