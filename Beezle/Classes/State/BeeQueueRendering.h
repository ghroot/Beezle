//
//  BeeQueueRendering.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class GameRulesSystem;

@interface BeeQueueRendering : NSObject
{
	CCLayer *_layer;
	CGPoint _position;
	GameRulesSystem *_gameRulesSystem;
	
	CCSpriteBatchNode *_beeQueueSpriteSheet;
	NSMutableArray *_beeQueueRenderSprites;
}

-(id) initWithLayer:(CCLayer *)layer position:(CGPoint)position gameRulesSystem:(GameRulesSystem *)gameRulesSystem;
-(void) update;

@end
