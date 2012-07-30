//
//  LevelThemeSelectMenuItem.m
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FullscreenTransparentMenuItem.h"

@implementation FullscreenTransparentMenuItem

-(id) initWithBlock:(void (^)(id))block selectedBlock:(void (^)(id))selectedBlock unselectedBlock:(void (^)(id))unselectedBlock
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCLayerColor *fullscreenLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0) width:winSize.width height:winSize.height];

	if (self = [super initWithNormalSprite:fullscreenLayer selectedSprite:nil disabledSprite:nil block:block])
	{
		if (selectedBlock != nil)
		{
			_selectedBlock = [selectedBlock copy];
		}
		if (unselectedBlock != nil)
		{
			_unselectedBlock = [unselectedBlock copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_selectedBlock release];
	[_unselectedBlock release];

	[super dealloc];
}

-(void) selected
{
	[super selected];

	if (isEnabled_ &&
		_selectedBlock != nil)
	{
		_selectedBlock(self);
	}
}

-(void) unselected
{
	[super unselected];

	if (isEnabled_ &&
		_unselectedBlock != nil)
	{
		_unselectedBlock(self);
	}
}

@end
