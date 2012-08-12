//
//  TutorialStripMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialStripMenuState.h"
#import "CCMenuNoTouchSwallow.h"
#import "Game.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@implementation TutorialStripMenuState

-(id) initWithFileName:(NSString *)fileName theme:(NSString *)theme
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
		CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"Syst-Check-%@.png", theme] selectedImage:[NSString stringWithFormat:@"Syst-Check2-%@.png", theme] block:^(id sender){
			if (_didDragEnoughToBlockMenuItems)
			{
				return;
			}
			[_game popState];
		}];
		[[menuItem selectedImage] setPosition:CGPointMake([menuItem contentSize].width / 2, [menuItem contentSize].height / 2)];
		[[menuItem selectedImage] setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[menuItem setPosition:CGPointMake(_contentWidth - 5.0f, 5.0f)];
		[menuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
		[menu setPosition:CGPointZero];
		[menu setAnchorPoint:CGPointZero];
		[menu addChild:menuItem];
		[_draggableNode addChild:menu];
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
