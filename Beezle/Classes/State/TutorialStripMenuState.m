//
//  TutorialStripMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TutorialStripMenuState.h"
#import "FullscreenTransparentMenuItem.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@implementation TutorialStripMenuState

-(id) initWithFileName:(NSString *)fileName
{
	if (self = [super init])
	{
		_draggableNode = [[CCSprite spriteWithFile:fileName] retain];
		[_draggableNode setAnchorPoint:CGPointZero];
		[self addChild:_draggableNode];

		CCMenu *menu = [CCMenu node];
		CCMenuItemFont *menuItem = [CCMenuItemFont itemWithString:@"OK" block:^(id sender){
			if (_didDragEnoughToBlockMenuItems)
			{
				return;
			}

			NSLog(@"YO");
		}];
		[menuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[menuItem setPosition:CGPointMake(winSize.width, 0.0f)];
		[menu setPosition:CGPointZero];
		[menu addChild:menuItem];
		[self addChild:menu];
	}
	return self;
}

-(void) dealloc
{
	[_draggableNode release];

	[super dealloc];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];

	if (_isDragging)
	{
		if (!_didDragEnoughToBlockMenuItems &&
			abs(_startDragTouchX - convertedLocation.x) >= DRAG_DISTANCE_BLOCK_MENU_ITEMS)
		{
			_didDragEnoughToBlockMenuItems = TRUE;
		}

		CGSize winSize = [[CCDirector sharedDirector] winSize];
		float newX = _startDragNodeX + (convertedLocation.x - _startDragTouchX);
		newX = min(0, newX);
		newX = max(-([_draggableNode contentSize].width - winSize.width), newX);
		[_draggableNode setPosition:CGPointMake(newX, 0)];
	}
	else
	{
		_isDragging = TRUE;
		_startDragTouchX = convertedLocation.x;
		_startDragNodeX = [_draggableNode position].x;
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	_isDragging = FALSE;
	_didDragEnoughToBlockMenuItems = FALSE;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

@end
