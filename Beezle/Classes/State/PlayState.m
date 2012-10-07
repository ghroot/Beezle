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
#import "CCBReader.h"
#import "SoundManager.h"
#import "TweenableSprite.h"
#import "SoundButton.h"

static int nextBeeIndex = 0;

@interface PlayState()

-(void) createGotoDebugMenu;
-(void) gotoDebugMenu;
-(void) createBee;
-(void) createSawee;
-(void) createBombee;
-(void) createBeeaters;

@end

@implementation PlayState

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CCBReader nodeGraphFromFile:@"Play.ccbi" owner:self]];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Interface-Animations.plist"];

		CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y + 2.0f)]];
		CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_menuItemPlay position].x, [_menuItemPlay position].y - 2.0f)]];
		CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
		[_menuItemPlay runAction:swayAction];

		_pollenExplodeSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Play/PlayButtonPollen-1.png"];
		[_pollenExplodeSprite setPosition:[_menuItemPlay position]];

		CCDelayTime *waitAction = [CCDelayTime actionWithDuration:4.0f];
		CCCallBlock *createBeeAction = [CCCallBlock actionWithBlock:^{
			if (nextBeeIndex == 0)
			{
				[self createBee];
			}
			else if (nextBeeIndex == 1)
			{
				[self createSawee];
			}
			else
			{
				[self createBombee];
			}
			nextBeeIndex++;
			if (nextBeeIndex > 2)
			{
				nextBeeIndex = 0;
			}
		}];
		CCRepeatForever *createBeesAction = [CCRepeatForever actionWithAction:[CCSequence actionOne:waitAction two:createBeeAction]];
		[[[CCDirector sharedDirector] actionManager] addAction:createBeesAction target:self paused:FALSE];

		[self createBeeaters];

		CGSize winSize = [[CCDirector sharedDirector] winSize];
		SoundButton *soundButton = [SoundButton node];
		[soundButton setPosition:CGPointMake(winSize.width / 2, 40.0f)];
		[self addChild:soundButton];

#ifdef DEBUG
		[self createGotoDebugMenu];
#endif
	}
	return self;
}

-(void) dealloc
{
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

	[self addChild:_pollenExplodeSprite];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Button-Explode"];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *gotoThemeSelectAction = [CCCallBlock actionWithBlock:^{
		[_game replaceState:[LevelThemeSelectMenuState state]];
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

-(void) createBee
{
	TweenableSprite *beeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Bee-1.png"];
	[beeSprite setPosition:CGPointMake(410.0f, 160.0f)];
	[beeSprite setScale:0.1f];
	[self addChild:beeSprite];

	CCAnimation *beeAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee"];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:beeAnimation];
	[beeSprite runAction:[CCRepeatForever actionWithAction:animateAction]];

	float duration = 2.2f;

	if (rand() % 2 == 0)
	{
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
	else
	{
		CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:duration scale:1.0f];
		id moveBeeLeftAction = [CCActionTween actionWithDuration:duration key:@"tweenableX" from:410.0f to:100.0f];
		id hitAction = [CCCallBlock actionWithBlock:^{
			[beeSprite stopAllActions];
			CCAnimate *hitAnimationAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee-Hit"]];
			CCAnimate *glideAnimationAction = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Bee-Glide"]];
			id glideDownAction = [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:3.0f position:CGPointMake(100.0f, -50.0f)]];
			CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:beeSprite cleanup:TRUE];
			}];
			id glideAndAnimate = [CCSpawn actionOne:[CCRepeat actionWithAction:glideAnimationAction times:INT_MAX] two:[CCSequence actionOne:glideDownAction two:removeAction]];
			[beeSprite runAction:[CCSequence actionOne:hitAnimationAction two:glideAndAnimate]];

			[[SoundManager sharedManager] playSound:@"BeeHitGlass"];
		}];
		id moveBeeUpAction = [CCEaseSineOut actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:160.0f to:240.0f]];
		id moveBeeDownAction = [CCEaseSineIn actionWithAction:[CCActionTween actionWithDuration:(duration / 2) key:@"tweenableY" from:240.0f to:50.0f]];
		[beeSprite runAction:scaleAction];
		[beeSprite runAction:[CCSequence actionOne:moveBeeLeftAction two:hitAction]];
		[beeSprite runAction:[CCSequence actionOne:moveBeeUpAction two:moveBeeDownAction]];
	}
}

-(void) createSawee
{
	TweenableSprite *saweeSprite = [TweenableSprite spriteWithSpriteFrameName:@"Play/Play-Sawee-1.png"];
	[saweeSprite setPosition:CGPointMake(410.0f, 160.0f)];
	[saweeSprite setScale:0.1f];
	[self addChild:saweeSprite];

	CCAnimation *saweeAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Sawee"];
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

-(void) createBeeaters
{
	CCSprite *beeaterMediumSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Beeater-m-1.png"];
	[beeaterMediumSprite setPosition:CGPointMake(436.0f, 63.0f)];
	[beeaterMediumSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Beeater-Medium"]]]];
	[self addChild:beeaterMediumSprite];

	CCSprite *beeaterSmallSprite = [CCSprite spriteWithSpriteFrameName:@"Play/Play-Beeater-s-1.png"];
	[beeaterSmallSprite setPosition:CGPointMake(140.0f, 96.0f)];
	[beeaterSmallSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Play-Beeater-Small"]]]];
	[self addChild:beeaterSmallSprite];
}

@end
