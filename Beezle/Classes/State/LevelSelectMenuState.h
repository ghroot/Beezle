//
//  LevelSelectMenuState.h
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface LevelSelectMenuState : GameState <CCTargetedTouchDelegate>
{
	NSString *_theme;
    CCNode *_draggableNode;
    BOOL _isDragging;
    float _startDragTouchX;
    float _startDragNodeX;
}

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme;

-(id) initWithTheme:(NSString *)theme;

@end
