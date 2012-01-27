//
//  PhysicsSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSystem.h"
#import "BodyInfo.h"
#import "CollisionSystem.h"
#import "Collision.h"
#import "GCpShapeCache.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

#define GRAVITY -100
#define FIXED_TIMESTEP (1.0f / 60.0f)

@implementation PhysicsSystem

@synthesize space = _space;

-(id) init
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [PhysicsComponent class], nil]])
    {
        _loadedShapeFileNames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_space release];
    [_loadedShapeFileNames release];
    
    [super dealloc];
}

-(void) initialise
{   
	_space = [[ChipmunkSpace alloc] init];
	[_space setSleepTimeThreshold:1.0f];
	[_space setData:self];
	[_space setGravity:CGPointMake(0.0f, GRAVITY)];
}

-(PhysicsComponent *) createPhysicsComponentWithFile:(NSString *)fileName bodyName:(NSString *)bodyName isStatic:(BOOL)isStatic collisionType:(cpCollisionType)collisionType
{
    if (![_loadedShapeFileNames containsObject:fileName])
    {
        [[GCpShapeCache sharedShapeCache] addShapesWithFile:fileName];
        [_loadedShapeFileNames addObject:fileName];
    }
    
    BodyInfo *bodyInfo = [[GCpShapeCache sharedShapeCache] createBodyWithName:bodyName];
    
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:[bodyInfo body] andShapes:[bodyInfo shapes]];
    
    for (ChipmunkShape *shape in [physicsComponent shapes])
    {
		[shape setCollisionType:collisionType];
    }
    
    return physicsComponent;
}

-(void) detectBeforeCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2
{
	[_space addCollisionHandler:self typeA:type1 typeB:type2 begin:@selector(beginCollision:space:) preSolve:nil postSolve:nil separate:nil];
}

-(void) detectAfterCollisionsBetween:(cpCollisionType)type1 and:(cpCollisionType)type2
{
	[_space addCollisionHandler:self typeA:type1 typeB:type2 begin:nil preSolve:nil postSolve:@selector(postSolveCollision:space:) separate:nil];
}

-(BOOL) beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{
    cpShape *firstShape;
    cpShape *secondShape;
    cpArbiterGetShapes(arbiter, &firstShape, &secondShape);
	
	ChipmunkShape *firstChipmunkShape = (ChipmunkShape *)firstShape->data;
	ChipmunkShape *secondChipmunkShape = (ChipmunkShape *)secondShape->data;
    
    Entity *firstEntity = (Entity *)[firstChipmunkShape data];
    Entity *secondEntity = (Entity *)[secondChipmunkShape data];
    
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[space data];
    CollisionSystem *collisionSystem = (CollisionSystem *)[[[physicsSystem world] systemManager] getSystem:[CollisionSystem class]];
    Collision *collision = [Collision collisionWithFirstEntity:firstEntity andSecondEntity:secondEntity];
    [collisionSystem pushCollision:collision];
    
    return FALSE;
}

-(void) postSolveCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{
    cpShape *firstShape;
    cpShape *secondShape;
    cpArbiterGetShapes(arbiter, &firstShape, &secondShape);
    
	ChipmunkShape *firstChipmunkShape = (ChipmunkShape *)firstShape->data;
	ChipmunkShape *secondChipmunkShape = (ChipmunkShape *)secondShape->data;
    
    Entity *firstEntity = (Entity *)[firstChipmunkShape data];
    Entity *secondEntity = (Entity *)[secondChipmunkShape data];
    
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[space data];
    CollisionSystem *collisionSystem = (CollisionSystem *)[[[physicsSystem world] systemManager] getSystem:[CollisionSystem class]];
    Collision *collision = [Collision collisionWithFirstEntity:firstEntity andSecondEntity:secondEntity];
    [collisionSystem pushCollision:collision];
}

-(void) entityAdded:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	if (![[physicsComponent body] isStatic])
	{
		[_space addBody:[physicsComponent body]];
	}
	
	for (ChipmunkShape *shape in [physicsComponent shapes])
	{
		[shape setData:entity];
		
		if ([[physicsComponent body] isStatic])
		{
			[_space addStaticShape:shape];
		}
		else
		{
			[_space addShape:shape];
		}
	}
}

-(void) entityRemoved:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	if (![[physicsComponent body] isStatic])
	{
		[_space removeBody:[physicsComponent body]];
	}
	
	for (ChipmunkShape *shape in [physicsComponent shapes])
	{
		[shape setData:nil];
		
		if ([[physicsComponent body] isStatic])
		{
			[_space removeStaticShape:shape];
		}
		else
		{
			[_space removeShape:shape];
		}
	}
}

-(void) begin
{
    if ([_world delta] > 0)
	{
		[_space step:FIXED_TIMESTEP];
	}
}

-(void) processEntity:(Entity *)entity
{   
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	if ([physicsComponent positionUpdatedManually])
	{
		// Moving a static body requires re-adding to the space
		if ([[physicsComponent body] isStatic])
		{
			for (ChipmunkShape *shape in [physicsComponent shapes])
			{
				[_space removeStaticShape:shape];
				[_space addStaticShape:shape];
			}
		}
		[physicsComponent setPositionUpdatedManually:FALSE];
	}
	
    [transformComponent setPosition:[[physicsComponent body] pos]];
    [transformComponent setRotation:CC_RADIANS_TO_DEGREES(-[[physicsComponent body] angle])];
}

@end
