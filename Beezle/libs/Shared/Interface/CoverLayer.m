//
//  CoverLayer.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoverLayer.h"

@implementation CoverLayer

-(id) initWithOpacity:(GLubyte)opacity instant:(BOOL)instant
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (self = [super initWithColor:ccc4(0, 0, 0, 0) width:winSize.width height:winSize.height])
	{
		[self setTouchPriority:kCCMenuHandlerPriority];
		[self setTouchMode:kCCTouchesOneByOne];
		[self setTouchEnabled:TRUE];

		if (instant)
		{
			[self setOpacity:opacity];
		}
		else
		{
			[self runAction:[CCFadeTo actionWithDuration:0.2f opacity:opacity]];
		}
    }
    return self;
}

-(id) initWithOpacity:(GLubyte)opacity
{
	return [self initWithOpacity:opacity instant:FALSE];
}

-(id) init
{
	return [self initWithOpacity:120];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return TRUE;
}

@end
