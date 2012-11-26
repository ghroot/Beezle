//
//  LevelSelectMenuState.h
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@class ScrollView;
@class BeesFrontNode;

@interface LevelSelectMenuState : GameState <CCTouchOneByOneDelegate>
{
	NSString *_theme;
	ScrollView *_scrollView;
	CCSprite *_chooserScreenSprite;
	BeesFrontNode *_beesFrontNode;
	CCLayer *_fadeLayer;
}

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme;

-(id) initWithTheme:(NSString *)theme;

@end
