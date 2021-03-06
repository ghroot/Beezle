//
//  LevelSelectMenuState.h
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"
#import "cocos2d.h"

@class ScrollView;
@class BeesFrontNode;

@interface LevelSelectMenuState : BeezleGameState <CCTouchOneByOneDelegate>
{
	NSString *_theme;
	ScrollView *_scrollView;
	CCSprite *_chooserScreenSprite;
	BeesFrontNode *_beesFrontNode;
	CCLayer *_fadeLayer;
	CCSprite *_pollenSprite;
	CCLabelAtlas *_pollenLabel;
}

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme;

-(id) initWithTheme:(NSString *)theme;

@end
