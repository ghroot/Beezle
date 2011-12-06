//
//  Beezle.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosStateBasedGame.h"
#import "slick.h"

typedef enum {
	STATE_MAIN_MENU,
	STATE_GAMEPLAY,
	STATE_INGAME_MENU,
    STATE_TEST,
} gameStates;

@interface Beezle : CocosStateBasedGame

@end
