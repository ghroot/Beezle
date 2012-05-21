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

/**
  Spawns pieces on disposal.
 */
@interface ShardComponent : Component
{
    // Type
	StringList *_piecesEntityTypes;
	int _piecesCount;
    ShardPiecesSpawnType _piecesSpawnType;
}

@property (nonatomic, readonly) int piecesCount;
@property (nonatomic, readonly) ShardPiecesSpawnType piecesSpawnType;

-(NSString *) randomPiecesEntityType;

@end
