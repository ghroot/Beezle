//
//  LevelThemeSelectMenuState.h
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"
#import "CCScrollLayer.h"

@class CCScrollLayer;

@interface LevelThemeSelectMenuState : GameState <CCScrollLayerDelegate>
{
	CCSprite *_backgroundSprite;
	float _backgroundSpriteWidth;
	CCScrollLayer *_scrollLayer;
	NSMutableArray *_pageDotSprites;
	CCSprite *_chooserScreenBackSprite;
	NSString *_theme;
	BOOL _zoomOut;
	CCLayerColor *_fadeLayer;
}

+(id) stateWithPreselectedTheme:(NSString *)theme zoomOut:(BOOL)zoomOut;

-(id) initWithPreselectedTheme:(NSString *)theme zoomOut:(BOOL)zoomOut;

-(void) zoomOut;

@end
