//
//  BeeQueueRenderingSystem.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class RenderSprite;
@class RenderSystem;

@interface BeeQueueRenderingSystem : TagEntitySystem
{
	RenderSystem *_renderSystem;
	int _z;
	
	NSMutableArray *_notifications;
	
	int _movingBeesCount;
	
	NSMutableArray *_beeQueueRenderSprites;
	RenderSprite *_beeLoadedRenderSprite;
}

-(id) initWithZ:(int)z;

@end
