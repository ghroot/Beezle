//
//  PlayState.m
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayState.h"
#import "Utils.h"
#import "Game.h"
#import "LevelThemeSelectMenuState.h"
#import "DebugMenuState.h"
#import "CCBReader.h"
#import "SoundManager.h"

@implementation PlayState

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CCBReader nodeGraphFromFile:@"Play.ccbi" owner:self]];

		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y + 2.0f)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y - 2.0f)]];
		CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
		[_menuItemPlay runAction:swayAction];
	}
	return self;
}

-(void) enter
{
	[super enter];

	[[SoundManager sharedManager] playMusic:@"MusicMain"];
}

-(void) play
{
	[_menu setEnabled:FALSE];
	[_menu setVisible:FALSE];

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
	NSArray *spriteFrames = [NSArray arrayWithObjects:
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-1.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-2.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-3.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-4.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-5.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-6.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-7.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PlayButtonPollen-8.png"],
			nil];

	CCSprite *pollenCatchSprite = [CCSprite spriteWithSpriteFrameName:@"Play/PlayButtonPollen-1.png"];
	[pollenCatchSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:pollenCatchSprite];

	CCAnimation *animation = [CCAnimation animationWithSpriteFrames:spriteFrames delay:0.05f];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *gotoThemeSelectAction = [CCCallBlock actionWithBlock:^{
		[_game replaceState:[LevelThemeSelectMenuState state]];
	}];
	[pollenCatchSprite runAction:[CCSequence actionOne:animateAction two:gotoThemeSelectAction]];

	[[SoundManager sharedManager] playSound:@"PollenCollect"];
}

-(void) gotoSettings
{
	[_game replaceState:[DebugMenuState state]];
}

@end
