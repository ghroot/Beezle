//
//  EntitySelectIngameMenuState.h
//  Beezle
//
//  Created by KM Lagerstrom on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface EntitySelectIngameMenuState : GameState
{
    CCMenu *_menu;
    NSArray *_alphabet;
}

-(id) initWithEntityTypes:(NSArray *)entityTypes;

@end
