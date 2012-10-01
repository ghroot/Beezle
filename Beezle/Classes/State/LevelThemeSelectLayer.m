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
#import "Game.h"
#import "LevelSelectMenuState.h"

@interface LevelThemeSelectLayer()

-(void) animateSprite:(CCSprite *)sprite animationName:(NSString *)animationName;
-(void) swaySprite:(CCSprite *)sprite speed:(float)speed;

@end

@implementation LevelThemeSelectLayer

-(id) initWithTheme:(NSString *)theme game:(Game *)game locked:(BOOL)locked
{
	if (self = [super init])
	{
		NSString *interfaceFileName = [NSString stringWithFormat:@"ThemeSelect-%@.ccbi", theme];
		[self addChild:[CCBReader nodeGraphFromFile:interfaceFileName owner:self]];

		[_lockSprite setVisible:locked];

		NSString *frameName;
		NSString *animationName;
		if ([theme isEqualToString:@"A"])
		{
			frameName = @"Chooser/Title-Bee-1.png";
			animationName = @"Title-Bee";
		}
		else if ([theme isEqualToString:@"B"])
		{
			frameName = @"Chooser/Title-Sumee-1.png";
			animationName = @"Title-Sumee";
		}
		else if ([theme isEqualToString:@"C"])
		{
			frameName = @"Chooser/Title-TBee-1.png";
			animationName = @"Title-TBee";
		}
		else
		{
			frameName = @"Chooser/Title-Mumee-1.png";
			animationName = @"Title-Mumee";
		}

		CCSprite *beeSprite = [CCSprite spriteWithSpriteFrameName:frameName];
		[beeSprite setPosition:CGPointMake(180.0f, 180.0f)];
		[self animateSprite:beeSprite animationName:animationName];
		[self swaySprite:beeSprite speed:0.4f];
		CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:2.0f scale:1.2f];
		CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:2.0f scale:0.8f];
		[beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]]];
		CCRotateTo *rotateRightAction = [CCRotateTo actionWithDuration:0.3f angle:5.0f];
		CCRotateTo *rotateLeftAction = [CCRotateTo actionWithDuration:0.3f angle:-5.0f];
		[beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		[self addChild:beeSprite];

		CCSprite *beeBackSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Title-BeeBack-1.png"];
		[beeBackSprite setPosition:CGPointMake(280.0f, 140.0f)];
		[self animateSprite:beeBackSprite animationName:@"Title-BeeBack"];
		rotateRightAction = [CCRotateTo actionWithDuration:0.6f angle:3.0f];
		rotateLeftAction = [CCRotateTo actionWithDuration:0.6f angle:-3.0f];
		[beeBackSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		[self addChild:beeBackSprite];

		int flowerRecordForTheme = [[PlayerInformation sharedInformation] flowerRecordForTheme:theme];
		int totalFlowersInTheme = [[[LevelOrganizer sharedOrganizer] levelNamesInTheme:theme] count] * 3;
		NSString *flowersString = [NSString stringWithFormat:@"%d/%d", flowerRecordForTheme, totalFlowersInTheme];
		CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:flowersString charMapFile:@"numberImages-red-s.png" itemWidth:12 itemHeight:14 startCharMap:'/'] autorelease];
		[label setAnchorPoint:CGPointZero];
		[label setPosition:[_flowerLabelPosition position]];
		[self addChild:label];

		_menu = [CCMenu new];
		if (!locked)
		{
			FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
				[game replaceState:[LevelSelectMenuState stateWithTheme:theme]];
			} selectedBlock:nil unselectedBlock:nil] autorelease];
			[_menu addChild:menuItem];
		}
		[self addChild:_menu];
	}
	return self;
}

-(void) dealloc
{
	[_menu release];

	[super dealloc];
}

-(void) animateSprite:(CCSprite *)sprite animationName:(NSString *)animationName
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCAnimate *animateActon = [CCAnimate actionWithAnimation:animation];
	[sprite runAction:[CCRepeatForever actionWithAction:animateActon]];
}

-(void) swaySprite:(CCSprite *)sprite speed:(float)speed
{
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y + 2.0f)]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y - 2.0f)]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	[sprite runAction:swayAction];
}

@end
