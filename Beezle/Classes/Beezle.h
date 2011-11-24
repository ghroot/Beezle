//
//  Beezle.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "slick.h"

typedef enum {
	STATE_MENU,
	STATE_GAMEPLAY,
    STATE_TEST,
} gameStates;

@interface Beezle : StateBasedGame

@end
