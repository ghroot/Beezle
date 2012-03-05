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

@interface BeeQueueRenderingSystem : EntityComponentSystem
{
	RenderSystem *_renderSystem;
	int _z;
	
	NSMutableArray *_notifications;
	
	int _movingBeesCount;
	
	NSMutableArray *_beeQueueRenderSprites;
	RenderSprite *_beeLoadedRenderSprite;
}

-(id) initWithZ:(int)z;

-(void) refreshSprites:(Entity *)slingerEntity;
-(BOOL) isBusy;

@end
