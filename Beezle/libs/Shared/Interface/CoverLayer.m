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
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (self = [super initWithColor:ccc4(0, 0, 0, 0) width:winSize.width height:winSize.height])
	{
//		[self setIsTouchEnabled:TRUE];
		
		[self runAction:[CCFadeTo actionWithDuration:0.2f opacity:50]];
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
