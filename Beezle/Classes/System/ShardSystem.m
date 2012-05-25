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

static const float PIECES_MIN_VELOCITY = 50.0f;
static const float PIECES_MAX_VELOCITY = 100.0f;
static const float PIECES_FADEOUT_DURATION = 7.0f;
static const float DERIVED_PIECES_PER_AREA = 0.0005f;

@interface ShardSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(int) derivePiecesCountFromBoundingBox:(cpBB)boundingBox;
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
		
		int numberOfPiecesToSpawn = [shardComponent piecesCount];
		if (numberOfPiecesToSpawn == 0)
		{
			numberOfPiecesToSpawn = [self derivePiecesCountFromBoundingBox:boundingBox];
		}
        
        NSMutableArray *pieceEntityTypes = [NSMutableArray array];
        for (int i = 0; i < numberOfPiecesToSpawn; i++)
        {
            if ([shardComponent piecesDistributionType] == SHARD_PIECES_DISTRIBUTION_RANDOM)
            {
                [pieceEntityTypes addObject:[shardComponent randomPiecesEntityType]];
            }
            else if ([shardComponent piecesDistributionType] == SHARD_PIECES_DISTRIBUTION_SEQUENTIAL)
            {
                [pieceEntityTypes addObject:[[shardComponent piecesEntityTypes] objectAtIndex:(i % [[shardComponent piecesEntityTypes] count])]];
            }
        }
		
		for (NSString *pieceEntityType in pieceEntityTypes)
		{
			// Create entity
			Entity *shardPieceEntity = [EntityFactory createEntity:pieceEntityType world:_world];
			
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

-(int) derivePiecesCountFromBoundingBox:(cpBB)boundingBox
{
	float area = (boundingBox.r - boundingBox.l) * (boundingBox.t - boundingBox.b);
	return (int)(area * DERIVED_PIECES_PER_AREA);
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
            ChipmunkNearestPointQueryInfo *queryInfo = [shape nearestPointQuery:randomPosition];
			if ([queryInfo dist] <= 0)
			{
				validPoint = TRUE;
			}
		}
	}
	return randomPosition;
}

@end
