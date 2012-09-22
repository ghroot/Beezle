//
//  LevelThemeSelectLayer.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LevelThemeSelectLayer : CCLayer
{
	CCNode *_container;
	CCSprite *_titleSprite;
	CCSprite *_beeSprite;
	CCSprite *_bee2Sprite;

	CCNode *_flowerLabelPosition;

	CCSprite *_lockSprite;

	CCMenu *_menu;
	CCLayerColor *_fadeLayer;
}

-(id) initWithTheme:(NSString *)theme startBlock:(void(^)(id sender))startBlock endBlock:(void(^)(id sender))endBlock locked:(BOOL)locked;

-(void) reset;

@end
