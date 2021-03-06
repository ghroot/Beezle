//
//  ShardSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShardSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "ShardComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "Utils.h"

static const float PIECES_MIN_VELOCITY = 40.0f;
static const float PIECES_MAX_VELOCITY = 80.0f;
static const float DERIVED_PIECES_PER_AREA = 0.001f;
static const int PIECES_MIN_NUMBER_OF_SHARDS = 1;
static const int PIECES_MAX_NUMBER_OF_SHARDS = 15;
static const float PIECES_FADEOUT_DURATION = 7.0f;

@interface ShardSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(NSArray *) createShardPieceEntities:(Entity *)entity;
-(NSArray *) generateShardPieceEntityTypes:(Entity *)entity;
-(int) calculateNumberOfShardPiecesToSpawn:(Entity *)entity;
-(int) derivePiecesCountFromBoundingBox:(cpBB)boundingBox;

@end

@implementation ShardSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[ShardComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_shardComponentMapper release];
	[_physicsComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) initialise
{
	_shardComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[ShardComponent class]];
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) entityAdded:(Entity *)entity
{
	ShardComponent *shardComponent = [_shardComponentMapper getComponentFor:entity];
	if ([shardComponent cacheShardPieceEntities])
	{
		NSArray *shardPieceEntities = [self createShardPieceEntities:entity];
		for (Entity *shardPieceEntity in shardPieceEntities)
		{
			[EntityUtil disableAllComponents:shardPieceEntity];
		}
		[shardComponent setCachedShardPieceEntities:shardPieceEntities];
	}
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[ShardComponent class]])
	{
		ShardComponent *shardComponent = [_shardComponentMapper getComponentFor:entity];
		PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];
		
		cpBB boundingBox = [physicsComponent boundingBox];
		
		NSArray *shardPieceEntities;
		if ([shardComponent cacheShardPieceEntities])
		{
			shardPieceEntities = [shardComponent cachedShardPieceEntities];
			for (Entity *pieceEntity in shardPieceEntities)
			{
				[EntityUtil enableAllComponents:pieceEntity];
			}
		}
		else
		{
			shardPieceEntities = [self createShardPieceEntities:entity];
		}
		
		for (Entity *shardPieceEntity in shardPieceEntities)
		{
			// Position
			CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
			[EntityUtil setEntityPosition:shardPieceEntity position:randomPosition];
			
			// Velocity
			PhysicsComponent *shardPiecePhysicsComponent = [_physicsComponentMapper getComponentFor:shardPieceEntity];
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

-(NSArray *) createShardPieceEntities:(Entity *)entity
{
	NSMutableArray *shardPieceEntities = [NSMutableArray array];
	ShardComponent *shardComponent = [_shardComponentMapper getComponentFor:entity];
	if ([shardComponent piecesAnimations] != nil)
	{
		for (NSDictionary *pieceAnimationDict in [shardComponent piecesAnimations])
		{
			Entity *shardPieceEntity = [EntityFactory createShardPieceEntity:_world animationName:[pieceAnimationDict objectForKey:@"pieceAnimation"] smallAnimationNames:[pieceAnimationDict objectForKey:@"smallPiecesAnimations"] spriteSheetName:[shardComponent piecesSpriteSheetName] animationFile:[shardComponent piecesAnimationFileName]];
			[shardPieceEntities addObject:shardPieceEntity];
		}
	}
	else
	{
		NSArray *shardPieceEntityTypes = [self generateShardPieceEntityTypes:entity];
		for (NSString *shardPieceEntityType in shardPieceEntityTypes)
		{
			Entity *shardPieceEntity = [EntityFactory createEntity:shardPieceEntityType world:_world];
			[shardPieceEntities addObject:shardPieceEntity];
		}
	}
	return shardPieceEntities;
}

-(NSArray *) generateShardPieceEntityTypes:(Entity *)entity
{
	ShardComponent *shardComponent = [_shardComponentMapper getComponentFor:entity];
	
	int numberOfPiecesToSpawn = [self calculateNumberOfShardPiecesToSpawn:entity];

	NSMutableArray *pieceEntityTypes = [NSMutableArray array];
	for (int i = 0; i < numberOfPiecesToSpawn; i++)
	{
		NSString *pieceEntityType = nil;
		if ([shardComponent piecesDistributionType] == SHARD_PIECES_DISTRIBUTION_RANDOM)
		{
			pieceEntityType = [shardComponent randomPiecesEntityType];
		}
		else if ([shardComponent piecesDistributionType] == SHARD_PIECES_DISTRIBUTION_SEQUENTIAL)
		{
			pieceEntityType = [[shardComponent piecesEntityTypes] objectAtIndex:(i % [[shardComponent piecesEntityTypes] count])];
		}
		if (pieceEntityType != nil)
		{
			[pieceEntityTypes addObject:pieceEntityType];
		}
	}
	
	return pieceEntityTypes;
}

-(int) calculateNumberOfShardPiecesToSpawn:(Entity *)entity
{
	ShardComponent *shardComponent = [_shardComponentMapper getComponentFor:entity];
	int numberOfPiecesToSpawn = [shardComponent piecesCount];
	if (numberOfPiecesToSpawn == 0)
	{
		PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];
		cpBB boundingBox = [physicsComponent boundingBox];
		numberOfPiecesToSpawn = [self derivePiecesCountFromBoundingBox:boundingBox];
	}
	numberOfPiecesToSpawn = (int)max(PIECES_MIN_NUMBER_OF_SHARDS, numberOfPiecesToSpawn);
	numberOfPiecesToSpawn = (int)min(PIECES_MAX_NUMBER_OF_SHARDS, numberOfPiecesToSpawn);

	return numberOfPiecesToSpawn;
}

-(int) derivePiecesCountFromBoundingBox:(cpBB)boundingBox
{
	float area = (boundingBox.r - boundingBox.l) * (boundingBox.t - boundingBox.b);
	return (int)(area * DERIVED_PIECES_PER_AREA);
}

@end
