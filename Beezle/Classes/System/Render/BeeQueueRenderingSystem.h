//
//  BeeQueueRenderingSystem.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class NotificationProcessor;
@class RenderSprite;
@class RenderSystem;

@interface BeeQueueRenderingSystem : EntityComponentSystem
{
	RenderSystem *_renderSystem;
	
	NotificationProcessor *_notificationProcessor;
	
	int _movingBeesCount;
	
	NSMutableArray *_beeQueueRenderSprites;
	RenderSprite *_beeLoadedRenderSprite;
}

-(void) refreshSprites;
-(BOOL) isBusy;
-(void) turnRemainingBeesIntoPollen;

@end
