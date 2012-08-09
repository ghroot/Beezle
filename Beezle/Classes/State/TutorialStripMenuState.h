//
//  TutorialStripMenuState.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@interface TutorialStripMenuState : GameState
{
	CCNode *_draggableNode;
	BOOL _isDragging;
	BOOL _didDragEnoughToBlockMenuItems;
	float _startDragTouchX;
	float _startDragNodeX;
}

-(id) initWithFileName:(NSString *)fileName;

@end
