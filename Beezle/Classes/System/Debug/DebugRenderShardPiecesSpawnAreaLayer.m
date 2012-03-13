//
//  DebugShardPiecesSpawnAreaRenderLayer.m
//  Beezle
//
//  Created by KM Lagerstrom on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderShardPiecesSpawnAreaLayer.h"
#import "ShardComponent.h"
#import "TransformComponent.h"

@implementation DebugRenderShardPiecesSpawnAreaLayer

@synthesize entitiesToDraw = _entitiesToDraw;

-(id) init
{
    if (self = [super init])
    {
        _entitiesToDraw = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_entitiesToDraw release];
    
    [super dealloc];
}

-(void) draw
{
	ccDrawColor4B(190, 190, 190, 190);
	
	for (Entity *entity in _entitiesToDraw)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		CGPoint position = [transformComponent position];
		ShardComponent *shardComponent = [ShardComponent getFrom:entity];
		CGSize size = [shardComponent piecesSpawnAreaSize];
		CGPoint offset = [shardComponent piecesSpawnAreaOffset];
		
		CGPoint topLeft = CGPointMake(position.x + offset.x - size.width / 2, position.y + offset.y - size.height / 2);
		CGPoint topRight = CGPointMake(position.x + offset.x + size.width / 2, position.y + offset.y - size.height / 2);
		CGPoint bottomRight = CGPointMake(position.x + offset.x + size.width / 2, position.y + offset.y + size.height / 2);
		CGPoint bottomLeft = CGPointMake(position.x + offset.x - size.width / 2, position.y + offset.y + size.height / 2);
		
		ccDrawLine(topLeft, topRight);
		ccDrawLine(topRight, bottomRight);
		ccDrawLine(bottomRight, bottomLeft);
		ccDrawLine(bottomLeft, topLeft);
	}
}

@end
