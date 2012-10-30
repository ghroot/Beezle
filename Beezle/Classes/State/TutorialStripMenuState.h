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
	CCSprite *_arrowSprite;
	void (^_block)();
}

-(id) initWithFileName:(NSString *)fileName theme:(NSString *)theme block:(void(^)())block;

@end
