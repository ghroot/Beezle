//
//  RenderTrajectorySystem.h
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@class RenderTrajectoryLayer;

@interface RenderTrajectorySystem : EntityComponentSystem
{
	CCScene *_scene;
	RenderTrajectoryLayer *_renderTrajectoryLayer;
}

-(id) initWithScene:(CCScene *)scene;

@end
