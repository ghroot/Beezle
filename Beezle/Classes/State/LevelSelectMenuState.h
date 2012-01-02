//
//  LevelSelectMenuState.h
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface LevelSelectMenuState : GameState
{
	NSString *_theme;
    CCMenu *_menu;
}

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme;

-(id) initWithTheme:(NSString *)theme;

-(void) startGame:(id)sender;
-(void) goBack:(id)sender;

@end
