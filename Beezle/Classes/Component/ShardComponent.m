//
//  GlassComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShardComponent.h"
#import "Utils.h"

@implementation ShardComponent

@synthesize piecesEntityType = _piecesEntityType;
@synthesize piecesCount = _piecesCount;
@synthesize piecesSpawnType = _piecesSpawnType;

-(id) init
{
	if (self = [super init])
	{
		_name = @"shard";
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _piecesEntityType = [[typeComponentDict objectForKey:@"piecesEntityType"] copy];
		if ([typeComponentDict objectForKey:@"piecesCount"] != nil)
		{
			_piecesCount = [[typeComponentDict objectForKey:@"piecesCount"] intValue];
		}
        if ([typeComponentDict objectForKey:@"piecesSpawnType"] != nil)
		{
            NSString *piecesSpawnTypeAsString = [typeComponentDict objectForKey:@"piecesSpawnType"];
            if ([piecesSpawnTypeAsString isEqualToString:@"SHARD_PIECES_SPAWN_FADEOUT"])
            {
                _piecesSpawnType = SHARD_PIECES_SPAWN_FADEOUT;
            }
            else if ([piecesSpawnTypeAsString isEqualToString:@"SHARD_PIECES_SPAWN_ANIMATE_AND_DELETE"])
            {
                _piecesSpawnType = SHARD_PIECES_SPAWN_ANIMATE_AND_DELETE;
            }
		}
        else
        {
            _piecesSpawnType = SHARD_PIECES_SPAWN_NORMAL;
        }
	}
	return self;
}

-(void) dealloc
{
	[_piecesEntityType release];
	
	[super dealloc];
}

@end
