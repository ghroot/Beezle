//
//  GlassComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringCollection;

typedef enum
{
	SHARD_PIECES_SPAWN_NORMAL,
    SHARD_PIECES_SPAWN_FADEOUT,
    SHARD_PIECES_SPAWN_ANIMATE_AND_DELETE
} ShardPiecesSpawnType;

typedef enum
{
    SHARD_PIECES_DISTRIBUTION_RANDOM,
    SHARD_PIECES_DISTRIBUTION_SEQUENTIAL
} ShardPiecesDistributionType;

/**
  Spawns pieces on disposal.
 */
@interface ShardComponent : Component
{
    // Type
	StringCollection *_piecesEntityTypes;
	int _piecesCount;
    ShardPiecesDistributionType _piecesDistributionType;
	NSString *_piecesSpriteSheetName;
	NSString *_piecesAnimationFileName;
	NSArray *_piecesAnimations;
	ShardPiecesSpawnType _piecesSpawnType;
	BOOL _cacheShardPieceEntities;
	
	// Transient
	NSArray *_cachedShardPieceEntities;
}

@property (nonatomic, readonly) int piecesCount;
@property (nonatomic, readonly) ShardPiecesDistributionType piecesDistributionType;
@property (nonatomic, copy) NSString *piecesSpriteSheetName;
@property (nonatomic, copy) NSString *piecesAnimationFileName;
@property (nonatomic, retain) NSArray *piecesAnimations;
@property (nonatomic, assign) ShardPiecesSpawnType piecesSpawnType;
@property (nonatomic, readonly) BOOL cacheShardPieceEntities;
@property (nonatomic, retain) NSArray *cachedShardPieceEntities;

-(NSArray *) piecesEntityTypes;
-(NSString *) randomPiecesEntityType;

@end
