//
//  CoverLayer.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoverLayer.h"

@implementation CoverLayer

-(id) init
{
    if (self = [super initWithColor:ccc4(0, 0, 0, 0) width:[CCDirector sharedDirector].winSize.width height:[CCDirector sharedDirector].winSize.height])
	{
		[self setIsTouchEnabled:TRUE];
		
		[self runAction:[CCFadeTo actionWithDuration:0.3f opacity:50]];
    }
    return self;
}

//-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//	return TRUE;
//}

//-(void) registerWithTouchDispatcher
//{
//	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:(INT_MIN + 1) swallowsTouches:TRUE];
//}

@end
