//
//  LevelThemeSelectLayer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectLayer.h"
#import "Utils.h"
#import "FullscreenTransparentMenuItem.h"

@implementation LevelThemeSelectLayer

-(id) initWithTheme:(NSString *)theme block:(void(^)(id sender))block
{
	if (self = [super init])
	{
		_container = [[CCNode alloc] init];
		[_container setPosition:[Utils getScreenCenterPosition]];
		[_container setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[self addChild:_container];

		NSString *globeImageFile = [NSString stringWithFormat:@"Globe-%@.png", theme];
		CCSprite *globeSprite = [CCSprite spriteWithFile:globeImageFile];
		[globeSprite setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_container addChild:globeSprite];
		CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:20.0f angle:360.0f];
		CCRepeatForever *repeatAction = [CCRepeatForever actionWithAction:rotateAction];
		[globeSprite runAction:repeatAction];

		CCSprite *shineSprite = [CCSprite spriteWithFile:@"ShineEffectGlobes.png"];
		[shineSprite setPosition:CGPointMake(-30.0f, 56.0f)];
		[_container addChild:shineSprite];

		NSString *titleImageFile = [NSString stringWithFormat:@"Title-%@.png", theme];
		CCSprite *titleSprite = [CCSprite spriteWithFile:titleImageFile];
		[titleSprite setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[_container addChild:titleSprite];

		CCMenu *menu = [CCMenu node];
		FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:3.0f];
			CCCallBlockO *callBlockAction = [CCCallBlockO actionWithBlock:block object:sender];
			[_container runAction:[CCSequence actionOne:scaleAction two:callBlockAction]];

			CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:0.2f];
			[_fadeLayer runAction:fadeInAction];
		} selectedBlock:nil unselectedBlock:nil] autorelease];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[menuItem setPosition:CGPointMake(-winSize.width / 2, -winSize.height / 2)];
		[menu addChild:menuItem];
		[_container addChild:menu];

		_fadeLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 0)];
		[self addChild:_fadeLayer];
	}
	return self;
}

-(void) dealloc
{
	[_container release];
	[_fadeLayer release];

	[super dealloc];
}

-(void) reset
{
	if (_container != nil)
	{
		[_container setScale:1.0f];
	}
	[_fadeLayer setOpacity:0];
}

@end
