//
//  TutorialStripMenuState.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"

@class ScrollView;

@interface TutorialStripMenuState : BeezleGameState
{
	ScrollView *_scrollView;
	CCSprite *_arrowSprite;
	void (^_block)();
}

-(id) initWithFileName:(NSString *)fileName buttonFileName:(NSString *)buttonFileName block:(void(^)())block;

@end
