//
//  LevelCompleteMode.h
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMode.h"
#import "cocos2d.h"

@class LevelSession;

@interface LevelCompletedMode : GameMode
{
	CCLayer *_uiLayer;
	LevelSession *_levelSession;
	BOOL _hasTurnedBeesIntoPollen;
	CCMenu *_levelCompletedMenu;
}

-(id) initWithGameplayState:(GameplayState *)gameplayState andUiLayer:(CCLayer *)uiLayer levelSession:(LevelSession *)levelSession;

@end
