//
//  ConfirmationState.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface ConfirmationState : GameState
{
	NSString *_title;
	void (^_block)();
	
	CCMenu *_menu;
}

+(id) stateWithTitle:(NSString *)title block:(void(^)())block;

-(id) initWithTitle:(NSString *)title block:(void(^)())block;

@end
