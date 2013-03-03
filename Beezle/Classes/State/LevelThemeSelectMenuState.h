//
//  LevelThemeSelectMenuState.h
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"
#import "cocos2d.h"
#import "CCScrollLayer.h"

@class CCScrollLayer;

@interface LevelThemeSelectMenuState : BeezleGameState <CCScrollLayerDelegate>
{
	NSArray *_themes;
	CCSprite *_backgroundSprite;
	float _backgroundSpriteWidth;
	CCScrollLayer *_scrollLayer;
	NSMutableArray *_pageDotSprites;
	NSString *_theme;
	int _numberOfPages;
	int _layerOffset;
}

+(id) stateWithPreselectedTheme:(NSString *)theme;

-(id) initWithPreselectedTheme:(NSString *)theme;

@end
