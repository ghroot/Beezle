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
	NSString *_theme;
	CCSprite *_flowerSprite;
	CCSprite *_lockSprite;
	CCSprite *_playSprite;
	CCMenu *_menu;
}

+(id) layerWithTheme:(NSString *)theme game:(Game *)game;

-(id) initWithTheme:(NSString *)theme game:(Game *)game;

-(void) enable;
-(void) disable;

@end
