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
#import "CollisionType.h"
#import "GCpShapeCache.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

#define GRAVITY -120

@interface PhysicsSystem()

-(BOOL) beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;

@end

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
    _collisionSystem = (CollisionSystem *)[[_world systemManager] getSystem:[CollisionSystem class]];
    
	_space = [[ChipmunkSpace alloc] init];
	[_space setSleepTimeThreshold:1.0f];
	[_space setData:self];
	[_space setGravity:CGPointMake(0.0f, GRAVITY)];
}

-(BodyInfo *) createBodyInfoFromFile:(NSString *)fileName bodyName:(NSString *)bodyName collisionType:(CollisionType *)collisionType
{
	if (![_loadedShapeFileNames containsObject:fileName])
    {
        [[GCpShapeCache sharedShapeCache] addShapesWithFile:fileName];
        [_loadedShapeFileNames addObject:fileName];
    }
    
    BodyInfo *bodyInfo = [[GCpShapeCache sharedShapeCache] createBodyWithName:bodyName];
    
	if (collisionType != nil)
	{
		for (ChipmunkShape *shape in [bodyInfo shapes])
		{
			[shape setCollisionType:collisionType];
		}
	}
    
    return bodyInfo;
}

-(void) detectCollisionsBetween:(CollisionType *)type1 and:(CollisionType *)type2
{
	[_space addCollisionHandler:self typeA:type1 typeB:type2 begin:@selector(beginCollision:space:) preSolve:nil postSolve:nil separate:nil];
}

-(BOOL) beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space
{	
	BOOL isFirstContact = cpArbiterIsFirstContact(arbiter);
	if (isFirstContact)
	{
		cpShape *firstShape;
		cpShape *secondShape;
		cpArbiterGetShapes(arbiter, &firstShape, &secondShape);
		
		ChipmunkShape *firstChipmunkShape = (ChipmunkShape *)firstShape->data;
		ChipmunkShape *secondChipmunkShape = (ChipmunkShape *)secondShape->data;
		
		Entity *firstEntity = (Entity *)[firstChipmunkShape data];
		Entity *secondEntity = (Entity *)[secondChipmunkShape data];
        
        cpVect impulse = cpArbiterTotalImpulse(arbiter);
		
		Collision *collision = [Collision collisionWithFirstEntity:firstEntity andSecondEntity:secondEntity];
		[collision setImpulse:impulse];
		[_collisionSystem pushCollision:collision];
    }
	
    return TRUE;
}

-(void) entityAdded:(Entity *)entity
{
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	
	if (![[physicsComponent body] isStatic] &&
		![physicsComponent isRougeBody])
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
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	
	if (![[physicsComponent body] isStatic] &&
		![physicsComponent isRougeBody])
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
    TransformComponent *transformComponent = [TransformComponent getFrom:entity];
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	
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
