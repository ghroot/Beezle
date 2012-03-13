//
//  ShardPiecesSpawnAreaRenderSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class DebugRenderShardPiecesSpawnAreaLayer;

@interface DebugRenderShardPiecesSpawnAreaSystem : EntityComponentSystem
{
	CCScene *_scene;
	DebugRenderShardPiecesSpawnAreaLayer *_debugRenderShardPiecesSpawnAreaLayer;
}

-(id) initWithScene:(CCScene *)scene;

@end
