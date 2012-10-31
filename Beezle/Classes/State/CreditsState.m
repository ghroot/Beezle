//
//  CreditsState
//  Beezle
//
//  Created by marcus on 31/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreditsState.h"
#import "ScrollView.h"
#import "Game.h"
#import "PlayState.h"

@interface CreditsState()

-(CCNode *) createCreditsNode;
-(void) createBackMenu;

@end

@implementation CreditsState

-(id) init
{
	if (self = [super init])
	{
		_scrollView = [ScrollView viewWithContent:[self createCreditsNode]];
		[_scrollView setScrollVertically:TRUE];
		[_scrollView setConstantVelocity:CGPointMake(0.0f, 0.5f)];
		[self addChild:_scrollView];

		[self createBackMenu];
	}
	return self;
}

-(CCNode *) createCreditsNode
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCNode *creditsNode = [CCNode node];

	// TEMP: Replace with actual credits
	for (int i = 1; i <= 20; i++)
	{
		CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Credit %d", i] fontName:@"Marker Felt" fontSize:30];
		[label setPosition:CGPointMake(winSize.width / 2, i * 30.0f)];
		[creditsNode addChild:label];
	}


	[creditsNode setContentSize:CGSizeMake(winSize.width, 640.0f)];

	return creditsNode;
}

-(void) createBackMenu
{
	CCMenu *backMenu = [CCMenu node];
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"Symbol-Next-White.png" selectedImage:@"Symbol-Next-White.png" block:^(id sender){
		[_game pushState:[PlayState state]];
	}];
	[backMenuItem setScaleX:-1.0f];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu z:40];
}

@end