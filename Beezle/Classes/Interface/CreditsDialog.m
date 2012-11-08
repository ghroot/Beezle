//
// Created by Marcus on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CreditsDialog.h"
#import "ScrollView.h"
#import "PlayState.h"
#import "CCBReader.h"
#import "SoundManager.h"

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

		[[SoundManager sharedManager] playMusic:@"MusicMain"];
	}
	return self;
}

-(ScrollView *) createScrollView
{
	ScrollView *scrollView = [ScrollView viewWithContent:[self createCreditsNode]];
	[scrollView setScrollVertically:TRUE];
	[scrollView setConstantVelocity:CGPointMake(0.0f, 0.5f)];
	[scrollView setConstantVelocityDelay:3.0f];
	return scrollView;
}

-(CCNode *) createCreditsNode
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCNode *creditsNode = [CCBReader nodeGraphFromFile:@"Credits.ccbi"];
	[creditsNode setAnchorPoint:CGPointMake(0.5f, 0.0f)];
	[creditsNode setPosition:CGPointMake(winSize.width / 2, winSize.height - [creditsNode contentSize].height)];
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