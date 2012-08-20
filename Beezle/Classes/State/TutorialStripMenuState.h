//
//  TutorialStripMenuState.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@class ScrollView;

@interface TutorialStripMenuState : GameState
{
	ScrollView *_scrollView;
}

-(id) initWithFileName:(NSString *)fileName theme:(NSString *)theme;

@end
