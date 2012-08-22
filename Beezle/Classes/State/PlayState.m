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

@implementation PlayState

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CCBReader nodeGraphFromFile:@"Play.ccbi" owner:self]];
	}
	return self;
}

-(void) play
{
	[_menu setEnabled:FALSE];
	[_menu setVisible:FALSE];

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
	NSArray *spriteFrames = [NSArray arrayWithObjects:
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-1.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-2.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-3.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-4.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-5.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-6.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-7.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/PollenCatchPlay-8.png"],
			nil];

	CCSprite *pollenCatchSprite = [CCSprite spriteWithSpriteFrameName:@"Play/PollenCatchPlay-1.png"];
	[pollenCatchSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:pollenCatchSprite];

	CCAnimation *animation = [CCAnimation animationWithSpriteFrames:spriteFrames delay:0.05f];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *gotoThemeSelectAction = [CCCallBlock actionWithBlock:^{
		[_game replaceState:[LevelThemeSelectMenuState state]];
	}];
	[pollenCatchSprite runAction:[CCSequence actionOne:animateAction two:gotoThemeSelectAction]];
}

-(void) gotoSettings
{
	[_game replaceState:[DebugMenuState state]];
}

@end
