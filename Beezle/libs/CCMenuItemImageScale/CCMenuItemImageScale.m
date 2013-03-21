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
	if (_isEnabled)
	{
		_isSelected = TRUE;

		[_normalImage setPosition:CGPointMake([self contentSize].width / 2, [self contentSize].height / 2)];
		[_normalImage setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_normalImage setScale:1.1f];
	}
}

-(void) unselected
{
	if (_isEnabled)
	{
		_isSelected = FALSE;

		[_normalImage setScale:1.0f];
	}
}

@end
