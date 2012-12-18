//
//  TutorialStripMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialStripMenuState.h"
#import "CCMenuNoTouchSwallow.h"
#import "ScrollView.h"
#import "CCMenuItemImageScale.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@implementation TutorialStripMenuState

-(id) initWithFileName:(NSString *)fileName buttonFileName:(NSString *)buttonFileName block:(void(^)())block
{
	if (self = [super init])
	{
		NSString *filePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
		CCSprite *singleSprite = [CCSprite spriteWithFile:filePath];
		CCNode *draggableNode;
		float contentWidth;
		if (singleSprite != nil)
		{
			draggableNode = singleSprite;
			contentWidth = [singleSprite contentSize].width;
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

			contentWidth = currentX;
			draggableNode = multiSprite;
		}
		[draggableNode setAnchorPoint:CGPointZero];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[draggableNode setContentSize:CGSizeMake(contentWidth, winSize.height)];

		CCMenu *menu = [CCMenuNoTouchSwallow node];
		CCMenuItemImageScale *menuItem = [CCMenuItemImageScale itemWithNormalImage:buttonFileName selectedImage:buttonFileName block:^(id sender){
			if ([_scrollView didDragSignificantDistance])
			{
				return;
			}
			_block();
		}];
		[menuItem setPosition:CGPointMake(contentWidth - 5.0f, 5.0f)];
		[menuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
		[menu setPosition:CGPointZero];
		[menu setAnchorPoint:CGPointZero];
		[menu addChild:menuItem];
		[draggableNode addChild:menu];

		_scrollView = [[ScrollView alloc] initWithContent:draggableNode];
		[_scrollView setScrollHorizontally:TRUE];
        [_scrollView setConstantVelocity:CGPointMake(-0.2f, 0.0f)];
		[self addChild:_scrollView];

		_arrowSprite = [CCSprite spriteWithFile:@"Symbol-Scroll-White.png"];
		[_arrowSprite setAnchorPoint:CGPointMake(1.0f, 0.5f)];
		[_arrowSprite setPosition:CGPointMake(winSize.width - 5.0f, winSize.height / 2)];
		[self addChild:_arrowSprite];

		_block = [block copy];
	}
	return self;
}

-(void) dealloc
{
	[_scrollView release];
	[_block release];

	[super dealloc];
}

-(void) update:(ccTime)delta
{
	[super update:delta];

	[_arrowSprite setVisible:[_scrollView distanceLeftToScrollRight] >= 15.0f];
}


@end
