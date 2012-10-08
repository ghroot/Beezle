//
//  DebugMenuState.h
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface DebugMenuState : GameState
{
    CCMenu *_menu;
	CCMenuItemFont *_toggleControlSchemeMenuItem;
}

@end
