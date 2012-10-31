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
	BOOL _scrollHorizontally;
	BOOL _scrollVertically;
	BOOL _isDragging;
	CGPoint _startDragTouchPosition;
	NSMutableArray *_previousDragTouchPositions;
	NSMutableArray *_touches;
	CGPoint _startDragNodePosition;
	CGPoint _velocity;
	BOOL _didDragSignificantDistance;
	CGPoint _constantVelocity;
}

@property (nonatomic) BOOL scrollHorizontally;
@property (nonatomic) BOOL scrollVertically;
@property (nonatomic) CGPoint constantVelocity;
@property (nonatomic, readonly) BOOL didDragSignificantDistance;

+(id) viewWithContent:(CCNode *)node;

-(id) initWithContent:(CCNode *)node;

-(float) distanceLeftToScrollRight;

@end
