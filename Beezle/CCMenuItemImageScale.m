//
//  CCMenuItemImageScale.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMenuItemImageScale.h"

@implementation CCMenuItemImageScale

-(void) selected
{
	if (isEnabled_)
	{
		isSelected_ = TRUE;

		[normalImage_ setPosition:CGPointMake([self contentSize].width / 2, [self contentSize].height / 2)];
		[normalImage_ setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[normalImage_ setScale:1.1f];
	}
}

-(void) unselected
{
	if (isEnabled_)
	{
		isSelected_ = FALSE;

		[normalImage_ setScale:1.0f];
	}
}

@end
