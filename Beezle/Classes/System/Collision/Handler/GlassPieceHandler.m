//
//  GlassPieceHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlassPieceHandler.h"
#import "Collision.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "TransformComponent.h"
#import "Utils.h"

@implementation GlassPieceHandler

+(id) handlerWithWorld:(World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

-(id) initWithWorld:(World *)world
{
    if (self = [super init])
    {
        _world = world;
    }
    return self;
}

-(void) handleCollision:(Collision *)collision
{
    Entity *glassPieceEntity = [collision firstEntity];
    
//	TransformComponent *transformComponent = [TransformComponent getFrom:glassPieceEntity];
//	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:glassPieceEntity];
//	for (int i = 0; i < 3; i++)
//	{
//		// Create entity
//		Entity *glassPieceSmallEntity = [EntityFactory createEntity:@"GLASS-PC-SMALL" world:_world];
//		
//		// Position
//		[EntityUtil setEntityPosition:glassPieceSmallEntity position:[transformComponent position]];
//		
//		// Velocity
//		PhysicsComponent *smallPhysicsComponent = [PhysicsComponent getFrom:glassPieceSmallEntity];
//		cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:20 and:50];
//		cpVect summedVelocity = cpv([[physicsComponent body] vel].x + randomVelocity.x, [[physicsComponent body] vel].y + randomVelocity.y);
//		[[smallPhysicsComponent body] setVel:summedVelocity];
//		
//		// Animation
//		RenderComponent *smallRenderComponent = [RenderComponent getFrom:glassPieceSmallEntity];
//		NSString *animationName = [NSString stringWithFormat:@"Glass-Pc%d-Idle", (1 + (rand() % 8))];
//		[[smallRenderComponent firstRenderSprite] playAnimation:animationName];
//		
//		// Fade out
//		[EntityUtil fadeOutAndDeleteEntity:glassPieceSmallEntity duration:4.0f];
//	}
	[glassPieceEntity deleteEntity];
	
    [EntityUtil playDefaultDestroySound:glassPieceEntity];
}

@end
