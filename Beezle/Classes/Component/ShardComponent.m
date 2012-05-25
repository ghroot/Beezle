//
//  GlassComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShardComponent.h"
#import "StringList.h"
#import "Utils.h"

@implementation ShardComponent

@synthesize piecesCount = _piecesCount;
@synthesize piecesSpawnType = _piecesSpawnType;
@synthesize piecesDistributionType = _piecesDistributionType;

-(id) init
{
	if (self = [super init])
	{
        _piecesEntityTypes = [StringList new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        [_piecesEntityTypes addStringsFromDictionary:typeComponentDict baseName:@"piecesEntityType"];
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
        if ([typeComponentDict objectForKey:@"piecesDistributionType"] != nil)
        {
            NSString *piecesDistributionTypeAsString = [typeComponentDict objectForKey:@"piecesDistributionType"];
            if ([piecesDistributionTypeAsString isEqualToString:@"SHARD_PIECES_DISTRIBUTION_RANDOM"])
            {
                _piecesDistributionType = SHARD_PIECES_DISTRIBUTION_RANDOM;
            }
            else if ([piecesDistributionTypeAsString isEqualToString:@"SHARD_PIECES_DISTRIBUTION_SEQUENTIAL"])
            {
                _piecesDistributionType = SHARD_PIECES_DISTRIBUTION_SEQUENTIAL;
            }
        }
        else
        {
            _piecesDistributionType = SHARD_PIECES_DISTRIBUTION_RANDOM;
        }
	}
	return self;
}

-(void) dealloc
{
	[_piecesEntityTypes release];
	
	[super dealloc];
}

-(NSArray *) piecesEntityTypes
{
    return [_piecesEntityTypes strings];
}

-(NSString *) randomPiecesEntityType
{
    return [_piecesEntityTypes randomString];
}

@end
