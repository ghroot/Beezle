//
//  LevelCompletedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedDialog.h"

#define IMAGE_PATH @"Bubble.png"

@implementation LevelCompletedDialog

-(id) initWithTarget:(id)target andSelector:(SEL)selector
{
	if (self = [super initWithImage:IMAGE_PATH])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCMenuItemFont *menuItemRestart = [CCMenuItemFont itemWithString:@"Next level" target:target selector:selector];
		[menuItemRestart setColor:ccc3(0, 0, 0)];
		[menuItemRestart setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
		[menuItemRestart setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		CCMenu *menu = [CCMenu menuWithItems:menuItemRestart, nil];
		[menu setPosition:CGPointZero];
		[_imageSprite addChild:menu];
	}
	return self;
}

@end
