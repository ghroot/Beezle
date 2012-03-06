//
//  GlassAnimationSystem.m
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
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "SoundComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "Utils.h"

#define PIECES_MIN_VELOCITY 50
#define PIECES_MAX_VELOCITY 100

@interface ShardSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleEntityCrumbled:(NSNotification *)notification;

@end

@implementation ShardSystem

-(id) init
{
	if (self = [super init])
	{
		_notifications = [[NSMutableArray alloc] init];
		[self addNotificationObservers];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_notifications release];
	
	[super dealloc];
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_ENTITY_CRUMBLED object:nil];
}

-(void) queueNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(void) begin
{
	while ([_notifications count] > 0)
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self handleNotification:nextNotification];
		[nextNotification release];
	}
}

-(void) handleNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_ENTITY_CRUMBLED])
	{
		[self handleEntityCrumbled:notification];
	}
}

-(void) handleEntityCrumbled:(NSNotification *)notification
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
			CGPoint randomPosition = CGPointMake(
						topLeft.x + (rand() % (int)[shardComponent piecesSpawnAreaSize].width),
						topLeft.y + (rand() % (int)[shardComponent piecesSpawnAreaSize].height));
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
		
		[[DisposableComponent getFrom:entity] setIsDisposed:TRUE];
		[entity deleteEntity];
		
		[[SoundManager sharedManager] playSound:[[SoundComponent getFrom:entity] defaultDestroySoundName]];
	}
}

@end
