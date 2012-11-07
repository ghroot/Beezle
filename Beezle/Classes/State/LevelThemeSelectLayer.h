//
//  LevelThemeSelectLayer.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class Game;

@interface LevelThemeSelectLayer : CCLayer
{
	CCSprite *_flowerSprite;
	CCSprite *_lockSprite;
	CCSprite *_playSprite;
	CCMenu *_menu;
}

-(id) initWithTheme:(NSString *)theme game:(Game *)game locked:(BOOL)locked;

@end
