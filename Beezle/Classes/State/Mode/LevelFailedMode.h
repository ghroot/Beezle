//
//  LevelFailedMode.h
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"
#import "cocos2d.h"

@class LevelSession;

@interface LevelFailedMode : GameMode
{
	CCLayer *_uiLayer;
	LevelSession *_levelSession;
	CCMenu *_levelFailedMenu;
}

-(id) initWithGameplayState:(GameplayState *)gameplayState andUiLayer:(CCLayer *)uiLayer levelSession:(LevelSession *)levelSession;

@end
