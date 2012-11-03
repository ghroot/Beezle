//
// Created by Marcus on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CreditsDialog.h"
#import "ScrollView.h"
#import "Game.h"
#import "PlayState.h"

@interface CreditsDialog()

-(ScrollView *) createScrollView;
-(CCNode *) createCreditsNode;
-(void) createBackMenu;

@end

@implementation CreditsDialog

+(id) dialogWithGame:(Game *)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

-(id) initWithGame:(Game *)game
{
	if (self = [super initWithNode:[self createScrollView] coverOpacity:128 instantCoverOpacity:TRUE])
	{
		_game = game;

		[self createBackMenu];
	}
	return self;
}

-(ScrollView *) createScrollView
{
	ScrollView *scrollView = [ScrollView viewWithContent:[self createCreditsNode]];
	[scrollView setScrollVertically:TRUE];
	[scrollView setConstantVelocity:CGPointMake(0.0f, 0.5f)];
	return scrollView;
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
		[_game clearAndReplaceState:[PlayState state]];
	}];
	[backMenuItem setScaleX:-1.0f];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu z:40];
}

@end