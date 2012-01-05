//
//  BeeQueueRenderingSystem.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class GameRulesSystem;
@class RenderSprite;

@interface BeeQueueRenderingSystem : TagEntitySystem
{
	CCLayer *_layer;
	
	NSMutableArray *_notifications;
	
	int _movingBeesCount;
	
	CCSpriteBatchNode *_beeQueueSpriteSheet;
	NSMutableArray *_beeQueueRenderSprites;
	RenderSprite *_beeLoadedRenderSprite;
}

-(id) initWithLayer:(CCLayer *)layer;

-(void) refreshSprites:(Entity *)slingerEntity;

@end
