//
//  SoundButton
//  Beezle
//
//  Created by marcus on 06/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundButton.h"
#import "SoundManager.h"
#import "PlayerInformation.h"

@interface SoundButton()

-(void) updateSoundMenuItemsVisibility;
-(void) muteSound;
-(void) unMuteSound;

@end

@implementation SoundButton

-(id) init
{
	if (self = [super init])
	{
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Chooser-Animations.plist"];

		_soundOnMenuItem = [CCMenuItemImage itemWithNormalImage:@"SoundButton-on.png" selectedImage:@"SoundButton-on.png" target:self selector:@selector(muteSound)];
		[_soundOnMenuItem setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_soundOnMenuItem setPosition:CGPointZero];
		_soundOffMenuItem = [CCMenuItemImage itemWithNormalImage:@"SoundButton-off.png" selectedImage:@"SoundButton-off.png" target:self selector:@selector(unMuteSound)];
		[_soundOffMenuItem setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_soundOffMenuItem setPosition:CGPointZero];
		_menu = [CCMenu menuWithItems:_soundOnMenuItem, _soundOffMenuItem, nil];
		[_menu setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_menu setPosition:CGPointZero];
		[self addChild:_menu];

		_soundButtonExplosionSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Play/SoundButton-pollen-1.png"];
		[_soundButtonExplosionSprite setPosition:[_soundOffMenuItem position]];

		[self updateSoundMenuItemsVisibility];
	}
	return self;
}

-(void) dealloc
{
	[_soundButtonExplosionSprite release];

	[super dealloc];
}


-(void) muteSound
{
	[_menu setEnabled:FALSE];
	[[SoundManager sharedManager] mute];
	[[PlayerInformation sharedInformation] setIsSoundMuted:TRUE];
	[[PlayerInformation sharedInformation] save];
	[_soundOnMenuItem setVisible:FALSE];
	[self createSoundButtonExplosionSprite:@"Sound-Button-Mute"];
}

-(void) unMuteSound
{
	[_menu setEnabled:FALSE];
	[[SoundManager sharedManager] unMute];
	[[PlayerInformation sharedInformation] setIsSoundMuted:FALSE];
	[[PlayerInformation sharedInformation] save];
	[_soundOffMenuItem setVisible:FALSE];
	[self createSoundButtonExplosionSprite:@"Sound-Button-Unmute"];
}

-(void) updateSoundMenuItemsVisibility
{
	if ([[PlayerInformation sharedInformation] isSoundMuted])
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

-(void) createSoundButtonExplosionSprite:(NSString *)animationName
{
	[self addChild:_soundButtonExplosionSprite];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:_soundButtonExplosionSprite cleanup:TRUE];
		[self updateSoundMenuItemsVisibility];
		[_menu setEnabled:TRUE];
	}];
	[_soundButtonExplosionSprite runAction:[CCSequence actionOne:animateAction two:removeAction]];
}

@end