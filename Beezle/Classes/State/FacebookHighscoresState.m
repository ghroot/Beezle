//
//  FacebookHighscoresState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FacebookHighscoresState.h"
#import "Game.h"
#import "PlayState.h"
#import "ScrollView.h"
#import "CCMenuItemImageScale.h"
#import "URLConnection.h"
#import "Utils.h"

@interface FacebookHighscoresState()

-(void) showLoadingSprite;
-(void) hideLoadingSprite;
-(void) createBackMenu;
-(BOOL) isPlayerUid:(NSString *)uid;

@end

@implementation FacebookHighscoresState

-(id) init
{
	if (self = [super init])
	{
		CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"PlayScene.jpg"];
		[backgroundSprite setPosition:[Utils screenCenterPosition]];
		[self addChild:backgroundSprite];

		CCLayerColor *coverLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100)];
		[self addChild:coverLayer];

		[self showLoadingSprite];

		[self createBackMenu];

		[[FacebookManager sharedManager] setDelegate:self];
		if ([[FacebookManager sharedManager] isLoggedIn])
		{
			[[FacebookManager sharedManager] getScores];
		}
		else
		{
			[[FacebookManager sharedManager] login];
		}
	}
	return self;
}

-(void) dealloc
{
	[[FacebookManager sharedManager] setDelegate:nil];

	[super dealloc];
}

-(void) didLogin
{
	[[FacebookManager sharedManager] getScores];
}

-(void) didRecieveUids:(NSArray *)uids names:(NSArray *)names scores:(NSArray *)scores
{
	[self hideLoadingSprite];

	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCNode *contentNode = [CCNode node];

	CCSprite *titleSprite = [CCSprite spriteWithFile:@"Text-My Friends High Score.png"];
	float contentHeight = 10.0f + [titleSprite contentSize].height + 10.0f + 70.0f * [uids count];
	[titleSprite setAnchorPoint:CGPointMake(0.5f, 1.0f)];
	[titleSprite setPosition:CGPointMake(winSize.width / 2, contentHeight - 10.0f)];
	[contentNode addChild:titleSprite];

	float centerX = winSize.width / 2;
	float currentY = contentHeight - (10.0f + [titleSprite contentSize].height + 10.0f) - 35.0f;

	for (int i = 0; i < [uids count]; i++)
	{
		NSString *uid = [uids objectAtIndex:i];
		NSString *name = [names objectAtIndex:i];
		NSString *score = [scores objectAtIndex:i];

		CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d. %@", (i + 1), name] fontName:@"Marker Felt" fontSize:18.0f];
		[nameLabel setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[nameLabel setPosition:CGPointMake(centerX - 60.0f, currentY)];
		[contentNode addChild:nameLabel];

		CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:score fontName:@"Marker Felt" fontSize:18.0f];
		[scoreLabel setAnchorPoint:CGPointMake(1.0f, 0.5f)];
		[scoreLabel setPosition:CGPointMake(centerX + 120.0f, currentY)];
		[contentNode addChild:scoreLabel];

		if ([self isPlayerUid:uid])
		{
			[nameLabel setColor:ccc3(255, 255, 0)];
			[scoreLabel setColor:ccc3(255, 255, 0)];
		}

		int portraitSize = (int)(CC_CONTENT_SCALE_FACTOR() * 50.0f);
		NSString *profilePictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", uid, portraitSize, portraitSize];
		[URLConnection asyncConnectionWithURLString:profilePictureUrl completionBlock:^(NSData *data, NSURLResponse *response){
			UIImage *imageFromURL = [UIImage imageWithData:data];
			CCSprite *sprite = [CCSprite spriteWithCGImage:[imageFromURL CGImage] key:[NSString stringWithFormat:@"player_image_%d", i]];
			[sprite setAnchorPoint:CGPointMake(0.0f, 0.5f)];
			[sprite setPosition:CGPointMake(centerX - 120.0f, currentY)];
			[contentNode addChild:sprite];
		} errorBlock:^(NSError *error){
		}];

		currentY -= 70.0f;
	}
	[contentNode setContentSize:CGSizeMake(winSize.width, contentHeight)];
	[contentNode setPosition:CGPointMake(0.0f, winSize.height - [contentNode contentSize].height)];

	ScrollView *scrollView = [ScrollView viewWithContent:contentNode];
	[scrollView setScrollVertically:TRUE];
	[self addChild:scrollView];
}

-(BOOL) isPlayerUid:(NSString *)uid
{
	NSString *playerUidString = [NSString stringWithFormat:@"%lld", [[FacebookManager sharedManager] playerFBID]];
	return [uid isEqualToString:playerUidString];
}

-(void) failedToGetScores
{
	[self hideLoadingSprite];

	CGSize winSize = [[CCDirector sharedDirector] winSize];

	NSString *errorMessage = @"Could not retrieve scores, please try again later";
	CCLabelTTF *errorLabel = [CCLabelTTF labelWithString:errorMessage fontName:@"Marker Felt" fontSize:20.0f];
	[errorLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[errorLabel setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
	[self addChild:errorLabel];
}

-(void) showLoadingSprite
{
	_loadingSprite = [CCSprite spriteWithFile:@"Syst-Text-Loading.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[_loadingSprite setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
	[self addChild:_loadingSprite];
}

-(void) hideLoadingSprite
{
	[self removeChild:_loadingSprite];
	_loadingSprite = nil;
}

-(void) createBackMenu
{
	CCMenu *backMenu = [CCMenu node];
	CCMenuItemImage *backMenuItem = [CCMenuItemImageScale itemWithNormalImage:@"Symbol-Next-White.png" selectedImage:@"Symbol-Next-White.png" block:^(id sender){
		[_game popStateWithTransition:FALSE];
	}];
	[backMenuItem setScaleX:-1.0f];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu];
}

@end
