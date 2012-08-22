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
#import "ScrollView.h"

static const int DRAG_DISTANCE_BLOCK_MENU_ITEMS = 10;

@implementation TutorialStripMenuState

-(id) initWithFileName:(NSString *)fileName theme:(NSString *)theme block:(void(^)())block
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
		CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"Syst-Check-%@.png", theme] selectedImage:[NSString stringWithFormat:@"Syst-Check2-%@.png", theme] block:^(id sender){
			if ([_scrollView didDragSignificantDistance])
			{
				return;
			}
			_block();
		}];
		[[menuItem selectedImage] setPosition:CGPointMake([menuItem contentSize].width / 2, [menuItem contentSize].height / 2)];
		[[menuItem selectedImage] setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[menuItem setPosition:CGPointMake(contentWidth - 5.0f, 5.0f)];
		[menuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
		[menu setPosition:CGPointZero];
		[menu setAnchorPoint:CGPointZero];
		[menu addChild:menuItem];
		[draggableNode addChild:menu];

		_scrollView = [[ScrollView alloc] initWithContent:draggableNode];
		[self addChild:_scrollView];

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


@end
