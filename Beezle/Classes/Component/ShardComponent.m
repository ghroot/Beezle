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
@synthesize piecesSpawnAreaOffset = _piecesSpawnAreaOffset;
@synthesize piecesSpawnAreaSize = _piecesSpawnAreaSize;

-(id) init
{
	if (self = [super init])
	{
		_name = @"shard";
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"piecesEntityType"] != nil)
		{
			_piecesEntityType = [[dict objectForKey:@"piecesEntityType"] copy];
		}
		if ([dict objectForKey:@"piecesCount"] != nil)
		{
			_piecesCount = [[dict objectForKey:@"piecesCount"] intValue];
		}
		if ([dict objectForKey:@"piecesSpawnAreaOffset"] != nil)
		{
			_piecesSpawnAreaOffset = [Utils stringToPoint:[dict objectForKey:@"piecesSpawnAreaOffset"]];
		}
		if ([dict objectForKey:@"piecesSpawnAreaSize"] != nil)
		{
			_piecesSpawnAreaSize = [Utils stringToSize:[dict objectForKey:@"piecesSpawnAreaSize"]];
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
