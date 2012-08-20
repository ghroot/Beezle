//
//  ScrollView.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/20/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ScrollView : CCLayer
{
	CCNode *_draggableNode;
	BOOL _isDragging;
	float _startDragTouchX;
	NSMutableArray *_previousDragTouchX;
	NSMutableArray *_touches;
	float _startDragNodeX;
	float _velocityX;
	BOOL _didDragSignificantDistance;
}

@property (nonatomic, readonly) BOOL didDragSignificantDistance;

+(id) viewWithContent:(CCNode *)node;

-(id) initWithContent:(CCNode *)node;

@end
