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

@interface ShardSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

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
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		ShardComponent *shardComponent = [ShardComponent getFrom:entity];
		
		CGPoint centerPoint = CGPointMake(
										  [transformComponent position].x + [shardComponent piecesSpawnAreaOffset].x,
										  [transformComponent position].y + [shardComponent piecesSpawnAreaOffset].y);
		CGPoint topLeft = CGPointMake(
									  centerPoint.x - [shardComponent piecesSpawnAreaSize].width / 2,
									  centerPoint.y - [shardComponent piecesSpawnAreaSize].height / 2);
		
		for (int i = 0; i < [shardComponent piecesCount]; i++)
		{
			// Create entity
			Entity *shardPieceEntity = [EntityFactory createEntity:[shardComponent piecesEntityType] world:_world];
			
			// Position
			CGPoint randomPosition = centerPoint;
			if ([shardComponent piecesSpawnAreaSize].width > 0)
			{
				randomPosition.x = topLeft.x + (rand() % (int)[shardComponent piecesSpawnAreaSize].width);
			}
			if ([shardComponent piecesSpawnAreaSize].height > 0)
			{
				randomPosition.y = topLeft.y + (rand() % (int)[shardComponent piecesSpawnAreaSize].height);
			}
			[EntityUtil setEntityPosition:shardPieceEntity position:randomPosition];
			
			// Velocity
			PhysicsComponent *shardPiecePhysicsComponent = [PhysicsComponent getFrom:shardPieceEntity];
			cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:PIECES_MIN_VELOCITY and:PIECES_MAX_VELOCITY];
			[[shardPiecePhysicsComponent body] setVel:randomVelocity];
			
			// Rotation velocity
			cpFloat randomAngularVelocity = -8.0f + ((rand() % 160) / 10.0f);
			[[shardPiecePhysicsComponent body] setAngVel:randomAngularVelocity];
			
			// Fade out
			[EntityUtil fadeOutAndDeleteEntity:shardPieceEntity duration:7.0f];
		}
		
		// TODO: Is this needed? Who is responsible for deleting entities?
		[entity deleteEntity];
	}
}

@end
