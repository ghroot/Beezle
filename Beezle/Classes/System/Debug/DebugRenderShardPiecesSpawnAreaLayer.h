//
//  DebugShardPiecesSpawnAreaRenderLayer.h
//  Beezle
//
//  Created by KM Lagerstrom on 12/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "artemis.h"

@interface DebugRenderShardPiecesSpawnAreaLayer : CCLayer
{
	NSMutableArray *_entitiesToDraw;
}

@property (nonatomic, retain) NSMutableArray *entitiesToDraw;

@end
