//
//  PollenSystem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 10/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;
@class RenderSystem;
@class LevelSession;

@interface PollenSystem : EntityComponentSystem
{
	RenderSystem *_renderSystem;

	ComponentMapper *_transformComponentMapper;
	ComponentMapper *_pollenComponentMapper;

	NotificationProcessor *_notificationProcessor;

	LevelSession *_levelSession;
}

-(id) initWithLevelSession:(LevelSession *)levelSession;

@end
