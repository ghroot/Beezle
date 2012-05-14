//
//  GlassComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

typedef enum
{
	SHARD_PIECES_SPAWN_NORMAL,
    SHARD_PIECES_SPAWN_FADEOUT,
    SHARD_PIECES_SPAWN_ANIMATE_AND_DELETE
} ShardPiecesSpawnType;

/**
  Spawns pieces on disposal.
 */
@interface ShardComponent : Component
{
    // Type
	NSString *_piecesEntityType;
	int _piecesCount;
    ShardPiecesSpawnType _piecesSpawnType;
}

@property (nonatomic, readonly) NSString *piecesEntityType;
@property (nonatomic, readonly) int piecesCount;
@property (nonatomic, readonly) ShardPiecesSpawnType piecesSpawnType;

@end
