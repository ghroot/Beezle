//
//  PlayState.m
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayState.h"
#import "Game.h"
#import "LevelThemeSelectMenuState.h"
#import "DebugMenuState.h"
#import "SoundManager.h"
#import "TweenableSprite.h"
#import "SoundButton.h"
#import "Utils.h"
#import "PlayerInformation.h"
#import "GameCenterManager.h"
#import "NotificationTypes.h"

static int nextBeeIndex = 0;

@interface PlayState()

-(void) createGotoDebugMenu;
-(void) gotoDebugMenu;
-(void) handleGameCenterNotification:(NSNotification *)notification;
-(void) updateGameCenterButton;
-(void) createBee;
-(void) createSawee;
-(void) createBombee;
-(void) createSpeedee;
-(void) createBeeaters;

@end

@implementation PlayState

-(id) init
{
	if (self = [super init])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];

		CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"PlayScene.jpg"];
		[backgroundSprite setPosition:[Utils screenCenterPosition]];
		[self addChild:backgroundSprite];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Play-Animations.plist"];

		_menuItemPlay = [CCMenuItemImage itemWithNormalImage:@"PlayButton.png" selectedImage:@"PlayButton.png" target:self selector:@selector(play)];
		[_menuItemPlay setPosition:CGPointMake(0.0f, -35.0f)];
		_menu = [CCMenu menuWithItems:_menuItemPlay, nil];
		[self addChild:_menu z:50];
		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y + 2.0f)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y - 2.0f)]];
		CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
		[_menuItemPlay runAction:swayAction];

		_pollenExplodeSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Play/PlayButtonPollen-1.png"];
		[_pollenExplodeSprite setPosition:CGPointMake(winSize.width / 2, winSize.height / 2 - 35.0f)];

		_universalScreenStartX = [Utils universalScreenStartX];

		CCDelayTime *waitAction = [CCDelayTime actionWithDuration:4.0f];
		CCCallBlock *createBeeAction = [CCCallBlock actionWithBlock:^{
			if (nextBeeIndex == 0)
			{
				[self createBee];
			}
			else if (nextBeeIndex == 1)
			{
				[self createSpeedee];
			}
			else if (nextBeeIndex == 2)
			{
				[self createSawee];
			}
			else
			{
				[self createBombee];
			}
			nextBeeIndex++;
			if (nextBeeIndex > 3)
			{
				nextBeeIndex = 0;
			}
		}];
		CCRepeatForever *createBeesAction = [CCRepeatForever actionWithAction:[CCSequence actionOne:waitAction two:createBeeAction]];
		[[[CCDirector sharedDirector] actionManager] addAction:createBeesAction target:self paused:FALSE];

		[self createBeeaters];

		SoundButton *soundButton = [SoundButton node];
		[self addChild:soundButton];

#ifndef LITE_VERSION
		[soundButton setPosition:CGPointMake(winSize.width / 2 - 30.0f, 40.0f)];

		CCMenu *gameCenterMenu = [CCMenu node];
		_gameCenterMenuItem = [CCMenuItemImage itemWithNormalImage:@"GameCentre logo-Idle.png" selectedImage:@"GameCentre logo-Push.png" block:^(id sender){
			[[GameCenterManager sharedManager] showLeaderboards];
		}];
		[[_gameCenterMenuItem selectedImage] setPosition:CGPointMake([_gameCenterMenuItem contentSize].width / 2, [_gameCenterMenuItem contentSize].height / 2)];
		[[_gameCenterMenuItem selectedImage] setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_gameCenterMenuItem setPosition:CGPointMake(winSize.width / 2 + 30.0f, 40.0f)];
		[gameCenterMenu setPosition:CGPointZero];
		[gameCenterMenu addChild:_gameCenterMenuItem];
		[self addChild:gameCenterMenu];
		[self updateGameCenterButton];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGameCenterNotification:) name:NOTIFICATION_GAME_CENTER_AUTHENTICATED object:nil];
#else
		[soundButton setPosition:CGPointMake(winSize.width / 2, 40.0f)];
#endif

#ifdef DEBUG
		[self createGotoDebugMenu];
#endif
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_pollenExplodeSprite release];

	[super dealloc];
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

	[self addChild:_pollenExplodeSprite z:50];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Button-Explode"];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *gotoThemeSelectAction = [CCCallBlock actionWithBlock:^{

		[_game replaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:[[PlayerInformation sharedInformation] defaultTheme]]];
	}];
	[_pollenExplodeSprite runAction:[CCSequence actionOne:animateAction two:gotoThemeSelectAction]];

	[[SoundManager sharedManager] playSound:@"PollenCollect"];
}

-(void) createGotoDebugMenu
{
	CCMenuItemFont *gotoDebugMenuItem = [CCMenuItemFont itemWithString:@"Debug" target:self selector:@selector(gotoDebugMenu)];
	[gotoDebugMenuItem setAnchorPoint:CGPointZero];
	[gotoDebugMenuItem setPosition:CGPointZero];
	[gotoDebugMenuItem setFontSize:20];
	CCMenu *gotoDebugMenu = [CCMenu menuWithItems:gotoDebugMenuItem, nil];
	[gotoDebugMenu setPosition:CGPointZero];
	[self addChild:gotoDebugMenu];
}

-(void) gotoDebugMenu
{
	[_game replaceState:[DebugMenuState state]];
}

-(void) handleGameCenterNotification:(NSNotification *)notification
{
	[self updateGameCenterButton];
}

-(void) updateGameCenterButton
{
	if ([[GameCenterManager sharedManager] isAuthenticated])
	{
		[_gameCenterMenuItem setIsEnabled:TRUE];
		[_gameCenterMenuItem setOpacity:255];
	}
	else
	{
		[_gameCenterMenuItem setIsEnabled:FALSE];
		[_gameCenterMenuItem setOpacity:128];
	}
}

-(void) createBee
{
	TweenableSprite *beeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Bee-1.png"];
	[beeSprite setPosition:CGPointMake(_universalScreenStartX + 456.0f, 158.0f)];
	[beeSprite setScale:0.1f];
	[self addChild:beeSprite z:40];

	CCAnimation *beeAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee"];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:beeAnimation];
	[beeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	if (rand() % 2 == 0)
	{
		float duration = 2.0f;

		CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.2f];
		id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:(_universalScreenStartX + 456.0f) to:(_universalScreenStartX + 305.0f)];
		CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
			[self removeChild:beeSprite cleanup:TRUE];
		}];
		id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:158.0f to:204.0f]];
		id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:204.0f to:-40.0f]];
		[beeSprite runAction:scaleAction];
		[beeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
		[beeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:removeAction]];
	}
	else
	{
		float duration = 1.5f;

		CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.0f];
		id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:(_universalScreenStartX + 456.0f) to:(_universalScreenStartX + 376.0f)];
		id hitAction = [CCCallBlock actionWithBlock:^{
			[beeSprite stopAllActions];
			CCAnimate *hitAnimationAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee-Hit"]];
			CCAnimate *glideAnimationAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee-Glide"]];
			id glideDownAction = [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:3.0f position:CGPointMake(_universalScreenStartX + 376.0f, -50.0f)]];
			CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:beeSprite cleanup:TRUE];
			}];
			id glideAndAnimate = [CCSpawn actionOne:glideAnimationAction two:[CCSequence actionOne:glideDownAction two:removeAction]];
			[beeSprite runAction:[CCSequence actionOne:hitAnimationAction two:glideAndAnimate]];

			[[SoundManager sharedManager] playSound:@"BeeHitScreen"];

			CCSprite *honeySprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Bee-Honey.png"];
			[honeySprite setPosition:CGPointMake([beeSprite position].x, [beeSprite position].y - 40.0f)];
			[honeySprite setOpacity:0];
			id fadeInAction = [CCFadeIn actionWithDuration:2.2f];
			id fadeOutAction = [CCFadeOut actionWithDuration:0.6f];
			id removeHoneyAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:honeySprite cleanup:TRUE];
			}];
			[honeySprite runAction:[CCSequence actions:fadeInAction, fadeOutAction, removeHoneyAction, nil]];
			[self addChild:honeySprite];
		}];
		id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:duration key:@"tweenableY" from:158.0f to:231.0f]];
		[beeSprite runAction:scaleAction];
		[beeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:hitAction]];
		[beeSprite runAction:moveBeeUpAction];
	}
}

-(void) createSawee
{
	TweenableSprite *saweeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Sawee-1.png"];
	[saweeSprite setPosition:CGPointMake(_universalScreenStartX + 245.0f, 141.0f)];
	[saweeSprite setScale:0.1f];
	[self addChild:saweeSprite z:40];

	CCAnimation *saweeAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Sawee"];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:saweeAnimation];
	[saweeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	if (rand() % 2 == 0)
	{
		float duration = 1.8f;

		CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.0f];
		id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:(_universalScreenStartX + 245.0f) to:(_universalScreenStartX + 142.0f)];
		id hitAction = [CCCallBlock actionWithBlock:^{

			id moveUpAction = [CCMoveTo actionWithDuration:0.5f position:CGPointMake(_universalScreenStartX + 110.0f, 360.0f)];
			id removeAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:saweeSprite cleanup:TRUE];
			}];
			[saweeSprite runAction:[CCSequence actionOne:moveUpAction two:removeAction]];

			[[SoundManager sharedManager] playSound:@"SaweeHitScreen"];

			CCSprite *cutSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Sawee-cut-2.png"];
			[cutSprite setPosition:CGPointMake([saweeSprite position].x - 50.0f, [saweeSprite position].y + 50.0f)];
			id cutAnimationAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Sawee-Cut"]];
			id fadeAction = [CCFadeOut actionWithDuration:1.0f];
			id removeCutAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:cutSprite cleanup:TRUE];
			}];
			[cutSprite runAction:[CCSequence actions:cutAnimationAction, fadeAction, removeCutAction, nil]];
			[self addChild:cutSprite];
		}];
		id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:141.0f to:158.0f]];
		id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:158.0f to:141.0f]];
		[saweeSprite runAction:scaleAction];
		[saweeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:hitAction]];
		[saweeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
	}
	else
	{
		float duration = 2.4f;

		CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.2f];
		id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:(_universalScreenStartX + 245.0f) to:(_universalScreenStartX - 80.0f)];
		id removeAction = [CCCallBlock actionWithBlock:^{
			[self removeChild:saweeSprite cleanup:TRUE];
		}];
		id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:141.0f to:158.0f]];
		id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:158.0f to:80.0f]];
		[saweeSprite runAction:scaleAction];
		[saweeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:removeAction]];
		[saweeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
	}
}

-(void) createBombee
{
	TweenableSprite *bombeeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Bombee-1.png"];
	[bombeeSprite setPosition:CGPointMake(_universalScreenStartX + 80.0f, 50.0f)];
	[self addChild:bombeeSprite z:40];

	CCAnimate *animateAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bombee"]];
	[bombeeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 2.0f;

	id scaleAction = [CCScaleTo actionWithDuration:duration scale:1.5f];
	id moveBeeRightAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:(_universalScreenStartX + 80.0f) to:(2 * _universalScreenStartX + 500.0f)];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:bombeeSprite cleanup:TRUE];
	}];
	id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:50.0f to:100.0f]];
	id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:100.0f to:30.0f]];
	[bombeeSprite runAction:scaleAction];
	[bombeeSprite runAction:[CCSequence actionOne:moveBeeRightAction two:removeAction]];
	[bombeeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
}

-(void) createSpeedee
{
	CCSprite *speedeeSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Speedee-1.png"];
	[speedeeSprite setPosition:CGPointMake(-20.0f, 264.0f)];
	[self addChild:speedeeSprite z:40];

	CCAnimate *animateAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Speedee"]];
	[speedeeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 1.0f;

	id moveBeeRightAction = [CCMoveTo actionWithDuration:duration position:CGPointMake(2 * _universalScreenStartX + 500.0f, 237.0f)];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:speedeeSprite cleanup:TRUE];
	}];
	id waitAction = [CCDelayTime actionWithDuration:0.2f];
	id spawnSmokeAction = [CCCallBlock actionWithBlock:^{
		CCSprite *smokeSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Speedee-Cloud-1.png"];
		[smokeSprite setPosition:CGPointMake([speedeeSprite position].x - 30.0f, [speedeeSprite position].y)];
		[self addChild:smokeSprite];
		CCAnimate *animateSmokeAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Speedee-Cloud"]];
		id removeSmokeAction = [CCCallBlock actionWithBlock:^{
			[self removeChild:smokeSprite cleanup:TRUE];
		}];
		[smokeSprite runAction:[CCSequence actionOne:animateSmokeAction two:removeSmokeAction]];
	}];
	[speedeeSprite runAction:[CCSequence actionOne:moveBeeRightAction two:removeAction]];
	[speedeeSprite runAction:[CCRepeat actionWithAction:[CCSequence actionOne:waitAction two:spawnSmokeAction] times:INT_MAX]];
}

-(void) createBeeaters
{
	CCSprite *beeaterMediumSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Beeater-m-1.png"];
	[beeaterMediumSprite setPosition:CGPointMake(_universalScreenStartX + 436.0f, 63.0f)];
	[beeaterMediumSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Beeater-Medium"]]]];
	[self addChild:beeaterMediumSprite z:30];

	CCSprite *beeaterSmallSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Beeater-s-1.png"];
	[beeaterSmallSprite setPosition:CGPointMake(_universalScreenStartX + 140.0f, 92.0f)];
	[beeaterSmallSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Beeater-Small"]]]];
	[self addChild:beeaterSmallSprite z:30];
}

@end
