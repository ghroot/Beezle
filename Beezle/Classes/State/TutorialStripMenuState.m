//
//  TutorialStripMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialStripMenuState.h"
#import "CCMenuNoTouchSwallow.h"
#import "FullscreenTransparentMenuItem.h"
#import "Game.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@implementation TutorialStripMenuState

-(id) initWithFileName:(NSString *)fileName
{
	if (self = [super init])
	{
		NSString *filePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
		CCSprite *singleSprite = [CCSprite spriteWithFile:filePath];
		if (singleSprite != nil)
		{
			_contentWidth = [singleSprite contentSize].width;
			_draggableNode = [singleSprite retain];
		}
		else
		{
			CCSprite *multiSprite = [CCSprite node];

			NSArray *stringComponents = [fileName componentsSeparatedByString:@"."];
			NSString *fileNameWithoutExtension = [stringComponents objectAtIndex:0];
			NSString *extension = [stringComponents objectAtIndex:1];
			int index = 1;
			float currentX = 0.0f;
			while (TRUE)
			{
				NSString *stringToAppend = [NSString stringWithFormat:@"-%d.", index];
				NSString *newFileName = [[fileNameWithoutExtension stringByAppendingString:stringToAppend] stringByAppendingString:extension];
				CCSprite *sectionSprite = [CCSprite spriteWithFile:newFileName];
				if (sectionSprite != nil)
				{
					[sectionSprite setPosition:CGPointMake(currentX, 0.0f)];
					[sectionSprite setAnchorPoint:CGPointZero];
					[multiSprite addChild:sectionSprite];
					currentX += [sectionSprite contentSize].width;
					index++;
				}
				else
				{
					break;
				}
			}

			_contentWidth = currentX;
			_draggableNode = [multiSprite retain];
		}
		[_draggableNode setAnchorPoint:CGPointZero];
		[self addChild:_draggableNode];

		CCMenu *menu = [CCMenuNoTouchSwallow node];
		FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			if (_didDragEnoughToBlockMenuItems)
			{
				return;
			}
			[_game popState];
		} selectedBlock:nil unselectedBlock:nil] autorelease];
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
		newX = max(-(_contentWidth - winSize.width), newX);
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
