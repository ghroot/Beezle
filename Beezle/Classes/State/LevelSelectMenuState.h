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

@interface LevelSelectMenuState : GameState <CCTargetedTouchDelegate>
{
	NSString *_theme;
	ScrollView *_scrollView;
}

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme;

-(id) initWithTheme:(NSString *)theme;

@end
