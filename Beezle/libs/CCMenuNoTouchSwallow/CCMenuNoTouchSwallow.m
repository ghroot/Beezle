//
//  CCMenuNoTouchSwallow.m
//  Beezle
//
//  Created by Marcus on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMenuNoTouchSwallow.h"

@implementation CCMenuNoTouchSwallow

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority swallowsTouches:NO];
}

@end
