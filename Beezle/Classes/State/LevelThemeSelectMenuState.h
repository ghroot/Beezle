//
//  LevelThemeSelectMenuState.h
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@class CCScrollLayer;

@interface LevelThemeSelectMenuState : GameState
{
	NSMutableArray *_backgroundSprites;
	NSMutableArray *_activeBackgroundSprites;
	CCScrollLayer *_scrollLayer;
}

-(void) resetCurrentLevelThemeSelectLayer;

@end
