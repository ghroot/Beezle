//
//  LevelThemeSelectLayer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectLayer.h"
#import "FullscreenTransparentMenuItem.h"
#import "CCBReader.h"
#import "PlayerInformation.h"
#import "LevelOrganizer.h"

@implementation LevelThemeSelectLayer

-(id) initWithTheme:(NSString *)theme block:(void(^)(id sender))block
{
	if (self = [super init])
	{
		NSString *interfaceFileName = [NSString stringWithFormat:@"ThemeSelect-%@-New.ccbi", theme];
		[self addChild:[CCBReader nodeGraphFromFile:interfaceFileName owner:self]];

		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_titleSprite position].x, [_titleSprite position].y + 2.0f)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_titleSprite position].x, [_titleSprite position].y - 2.0f)]];
		CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
		[_titleSprite runAction:swayAction];

		if (_beeSprite != nil)
		{
			CCMoveTo *moveUpAction2 = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake([_beeSprite position].x, [_beeSprite position].y + 1.0f)]];
			CCMoveTo *moveDownAction2 = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake([_beeSprite position].x, [_beeSprite position].y - 1.0f)]];
			CCAction *swayAction2 = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction2, moveDownAction2, nil] times:INT_MAX];
			[_beeSprite runAction:swayAction2];
			CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:2.0f scale:1.2f];
			CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:2.0f scale:0.8f];
			[_beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]]];
			CCRotateTo *rotateRightAction = [CCRotateTo actionWithDuration:0.3f angle:5.0f];
			CCRotateTo *rotateLeftAction = [CCRotateTo actionWithDuration:0.3f angle:-5.0f];
			[_beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		}
		if (_bee2Sprite != nil)
		{
			CCRotateTo *rotateRightAction = [CCRotateTo actionWithDuration:0.6f angle:3.0f];
			CCRotateTo *rotateLeftAction = [CCRotateTo actionWithDuration:0.6f angle:-3.0f];
			[_bee2Sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		}

		int flowerRecordForTheme = [[PlayerInformation sharedInformation] flowerRecordForTheme:theme];
		int totalFlowersInTheme = [[[LevelOrganizer sharedOrganizer] levelNamesInTheme:theme] count] * 3;
		NSString *flowersString = [NSString stringWithFormat:@"%d/%d", flowerRecordForTheme, totalFlowersInTheme];
		CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:flowersString charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'] autorelease];
		[label setAnchorPoint:CGPointZero];
		[label setPosition:[_flowerLabelPosition position]];
		[self addChild:label];

		CCMenu *menu = [CCMenu node];
		FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:3.0f];
			CCCallBlockO *callBlockAction = [CCCallBlockO actionWithBlock:block object:sender];
			[_container runAction:[CCSequence actionOne:scaleAction two:callBlockAction]];

			CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:0.2f];
			[_fadeLayer runAction:fadeInAction];
		} selectedBlock:nil unselectedBlock:nil] autorelease];
		[menu addChild:menuItem];
		[self addChild:menu];

		_fadeLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 0)];
		[self addChild:_fadeLayer];
	}
	return self;
}

-(void) dealloc
{
	[_fadeLayer release];

	[super dealloc];
}

-(void) reset
{
	[_container setScale:2.0f];
	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:1.0f];
	[_container runAction:scaleAction];

	[_fadeLayer setOpacity:255];
	CCFadeIn *fadeOutAction = [CCFadeOut actionWithDuration:0.2f];
	[_fadeLayer runAction:fadeOutAction];
}

@end
