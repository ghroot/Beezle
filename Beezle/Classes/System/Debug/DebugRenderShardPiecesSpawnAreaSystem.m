//
//  ShardPiecesSpawnAreaRenderSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderShardPiecesSpawnAreaSystem.h"
#import "DebugRenderShardPiecesSpawnAreaLayer.h"
#import "ShardComponent.h"

@implementation DebugRenderShardPiecesSpawnAreaSystem

-(id) initWithScene:(CCScene *)scene
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[ShardComponent class]]])
	{
		_scene = scene;
		_debugRenderShardPiecesSpawnAreaLayer = [DebugRenderShardPiecesSpawnAreaLayer new];
		[_scene addChild:_debugRenderShardPiecesSpawnAreaLayer];
	}
	return self;
}

-(void) dealloc
{
	if ([_debugRenderShardPiecesSpawnAreaLayer parent] == _scene)
	{
		[_scene removeChild:_debugRenderShardPiecesSpawnAreaLayer cleanup:TRUE];
	}
	[_debugRenderShardPiecesSpawnAreaLayer release];
	
	[super dealloc];
}

-(void) begin
{
    [[_debugRenderShardPiecesSpawnAreaLayer entitiesToDraw] removeAllObjects];
}

-(void) processEntity:(Entity *)entity
{
	[[_debugRenderShardPiecesSpawnAreaLayer entitiesToDraw] addObject:entity];
}

-(void) activate
{
	[super activate];
	[_scene addChild:_debugRenderShardPiecesSpawnAreaLayer];
}

-(void) deactivate
{
	[super deactivate];
	[_scene removeChild:_debugRenderShardPiecesSpawnAreaLayer cleanup:TRUE];
}

@end
