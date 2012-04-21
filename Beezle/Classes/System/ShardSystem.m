//
//  ShardSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShardSystem.h"
#import "DisposableComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "ShardComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"
#import "Utils.h"

#define PIECES_MIN_VELOCITY 50
#define PIECES_MAX_VELOCITY 100
#define PIECES_FADEOUT_DURATION 7.0f

@interface ShardSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(CGPoint) getRandomPositionWithinShapes:(NSArray *)shapes boundingBox:(cpBB)boundingBox;

@end

@implementation ShardSystem

-(id) init
{
	if (self = [super init])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[ShardComponent class]])
	{
		ShardComponent *shardComponent = [ShardComponent getFrom:entity];
		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];	
		
		cpBB boundingBox = [physicsComponent boundingBox];
		
		for (int i = 0; i < [shardComponent piecesCount]; i++)
		{
			// Create entity
			Entity *shardPieceEntity = [EntityFactory createEntity:[shardComponent piecesEntityType] world:_world];
			
			// Position
			CGPoint randomPosition = [self getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
			[EntityUtil setEntityPosition:shardPieceEntity position:randomPosition];
			
			// Velocity
			PhysicsComponent *shardPiecePhysicsComponent = [PhysicsComponent getFrom:shardPieceEntity];
			cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:PIECES_MIN_VELOCITY and:PIECES_MAX_VELOCITY];
			[[shardPiecePhysicsComponent body] setVel:randomVelocity];
			
			// Rotation velocity
			cpFloat randomAngularVelocity = -8.0f + ((rand() % 160) / 10.0f);
			[[shardPiecePhysicsComponent body] setAngVel:randomAngularVelocity];
			
            if ([shardComponent piecesSpawnType] == SHARD_PIECES_SPAWN_FADEOUT)
            {
                // Fade out
                [EntityUtil fadeOutAndDeleteEntity:shardPieceEntity duration:PIECES_FADEOUT_DURATION];
            }
            else if ([shardComponent piecesSpawnType] == SHARD_PIECES_SPAWN_ANIMATE_AND_DELETE)
            {
                // Animate and delete
                [EntityUtil animateAndDeleteEntity:shardPieceEntity disablePhysics:FALSE];
            }
		}
	}
}

-(CGPoint) getRandomPositionWithinShapes:(NSArray *)shapes boundingBox:(cpBB)boundingBox
{
	CGPoint randomPosition;
	BOOL validPoint = FALSE;
	while (!validPoint)
	{
		randomPosition = CGPointMake(boundingBox.l + rand() % (int)(boundingBox.r - boundingBox.l), boundingBox.b + rand() % (int)(boundingBox.t - boundingBox.b));
		for (ChipmunkShape *shape in shapes)
		{
			if ([shape pointQuery:randomPosition])
			{
				validPoint = TRUE;
			}
		}
	}
	return randomPosition;
}

@end
