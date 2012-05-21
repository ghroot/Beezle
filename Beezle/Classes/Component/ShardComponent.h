//
//  GlassComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringList;

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
	StringList *_piecesEntityTypes;
	int _piecesCount;
    ShardPiecesSpawnType _piecesSpawnType;
    ShardPiecesDistributionType _piecesDistributionType;
}

@property (nonatomic, readonly) int piecesCount;
@property (nonatomic, readonly) ShardPiecesSpawnType piecesSpawnType;
@property (nonatomic, readonly) ShardPiecesDistributionType piecesDistributionType;

-(NSArray *) piecesEntityTypes;
-(NSString *) randomPiecesEntityType;

@end
