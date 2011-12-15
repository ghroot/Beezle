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

@interface BeeQueueRenderingSystem : TagEntitySystem
{
	CCLayer *_layer;
	
	NSMutableArray *_notifications;
	
	CCSpriteBatchNode *_beeQueueSpriteSheet;
	NSMutableArray *_beeQueueRenderSprites;
}

-(id) initWithLayer:(CCLayer *)layer;

@end
