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
#import "TweenableSprite.h"

@interface PlayState()

-(void) updateSoundMenuItemsVisibility;
-(void) createBee;
-(void) createSawee;
-(void) createBombee;

@end

@implementation PlayState

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CCBReader nodeGraphFromFile:@"Play.ccbi" owner:self]];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];

		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y + 2.0f)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y - 2.0f)]];
		CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
		[_menuItemPlay runAction:swayAction];

		[self updateSoundMenuItemsVisibility];

		CCDelayTime *waitAction = [CCDelayTime actionWithDuration:4.0f];
		CCCallBlock *createBeeAction = [CCCallBlock actionWithBlock:^{
			int randomBee = rand() % 3;
			if (randomBee == 0)
			{
				[self createBee];
			}
			else if (randomBee == 1)
			{
				[self createSawee];
			}
			else
			{
				[self createBombee];
			}
		}];
		CCRepeatForever *createBeesAction = [CCRepeatForever actionWithAction:[CCSequence actionOne:waitAction two:createBeeAction]];
		[[[CCDirector sharedDirector] actionManager] addAction:createBeesAction target:self paused:FALSE];
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

-(void) muteSound
{
	[[SoundManager sharedManager] mute];
	[self updateSoundMenuItemsVisibility];
}

-(void) unMuteSound
{
	[[SoundManager sharedManager] unMute];
	[self updateSoundMenuItemsVisibility];
}

-(void) updateSoundMenuItemsVisibility
{
	if ([[SoundManager sharedManager] isMuted])
	{
		[_soundOnMenuItem setVisible:FALSE];
		[_soundOffMenuItem setVisible:TRUE];
	}
	else
	{
		[_soundOnMenuItem setVisible:TRUE];
		[_soundOffMenuItem setVisible:FALSE];
	}
}

-(void) createBee
{
	TweenableSprite *beeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Bee-1.png"];
	[beeSprite setPosition:CGPointMake(410.0f, 160.0f)];
	[beeSprite setScale:0.1f];
	[self addChild:beeSprite];

	NSArray *beeSpriteFrames = [NSArray arrayWithObjects:
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Bee-1.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Bee-2.png"],
			nil];
	CCAnimation *beeAnimation = [CCAnimation animationWithSpriteFrames:beeSpriteFrames delay:0.08f];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:beeAnimation];
	[beeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 2.2f;

	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.0f];
	id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:410.0f to:-50.0f];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:beeSprite cleanup:TRUE];
	}];
	id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:160.0f to:250.0f]];
	id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:250.0f to:50.0f]];
	[beeSprite runAction:scaleAction];
	[beeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:removeAction]];
	[beeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
}

-(void) createSawee
{
	TweenableSprite *saweeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Sawee-1.png"];
	[saweeSprite setPosition:CGPointMake(410.0f, 160.0f)];
	[saweeSprite setScale:0.1f];
	[self addChild:saweeSprite];

	NSArray *saweeSpriteFrames = [NSArray arrayWithObjects:
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Sawee-1.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Sawee-2.png"],
			nil];
	CCAnimation *saweeAnimation = [CCAnimation animationWithSpriteFrames:saweeSpriteFrames delay:0.08f];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:saweeAnimation];
	[saweeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 2.2f;

	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.0f];
	id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:410.0f to:120.0f];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:saweeSprite cleanup:TRUE];
	}];
	id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:160.0f to:200.0f]];
	id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:200.0f to:-60.0f]];
	[saweeSprite runAction:scaleAction];
	[saweeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:removeAction]];
	[saweeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
}

-(void) createBombee
{
	TweenableSprite *bombeeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Bombee-1.png"];
	[bombeeSprite setPosition:CGPointMake(80.0f, 50.0f)];
	[self addChild:bombeeSprite];

	NSArray *bombeeSpriteFrames = [NSArray arrayWithObjects:
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Bombee-1.png"],
			[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Play/Play-Bombee-2.png"],
			nil];
	CCAnimation *bombeeAnimation = [CCAnimation animationWithSpriteFrames:bombeeSpriteFrames delay:0.08f];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:bombeeAnimation];
	[bombeeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 2.0f;

	id scaleAction = [CCScaleTo actionWithDuration:duration scale:1.5f];
	id moveBeeRightAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:80.0f to:500.0f];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:bombeeSprite cleanup:TRUE];
	}];
	id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:50.0f to:100.0f]];
	id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:100.0f to:30.0f]];
	[bombeeSprite runAction:scaleAction];
	[bombeeSprite runAction:[CCSequence actionOne:moveBeeRightAction two:removeAction]];
	[bombeeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
}

@end
