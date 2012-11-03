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

-(void) animateSprite:(CCSprite *)sprite animationNames:(NSArray *)animationNames;
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
		[_playSprite setVisible:!locked];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Chooser-Animations.plist"];

		NSMutableArray *animationNames = [NSMutableArray array];
		if ([theme isEqualToString:@"A"])
		{
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Idle"];
			[animationNames addObject:@"Title-Bee-Blink"];
		}
		else if ([theme isEqualToString:@"B"])
		{
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Fart"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Idle"];
			[animationNames addObject:@"Title-Sumee-Blink"];
		}
		else if ([theme isEqualToString:@"C"])
		{
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Idle"];
			[animationNames addObject:@"Title-TBee-Blink"];
		}
		else
		{
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Idle"];
			[animationNames addObject:@"Title-Mumee-Blink"];
		}

		CCSprite *beeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[beeSprite setPosition:CGPointMake(180.0f, 180.0f)];
		[self animateSprite:beeSprite animationNames:animationNames];
		[self swaySprite:beeSprite speed:0.4f];
		CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:2.0f scale:1.2f];
		CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:2.0f scale:0.8f];
		[beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]]];
		CCRotateTo *rotateRightAction = [CCRotateTo actionWithDuration:0.3f angle:5.0f];
		CCRotateTo *rotateLeftAction = [CCRotateTo actionWithDuration:0.3f angle:-5.0f];
		[beeSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		[self addChild:beeSprite];

		CCSprite *beeBackSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[beeBackSprite setPosition:CGPointMake(280.0f, 140.0f)];
		[self animateSprite:beeBackSprite animationNames:[NSArray arrayWithObject:@"Title-BeeBack-Idle"]];
		rotateRightAction = [CCRotateTo actionWithDuration:0.6f angle:3.0f];
		rotateLeftAction = [CCRotateTo actionWithDuration:0.6f angle:-3.0f];
		[beeBackSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		[self addChild:beeBackSprite];

		int flowerRecordForTheme = [[PlayerInformation sharedInformation] flowerRecordForTheme:theme];
		NSString *flowersString = [NSString stringWithFormat:@"%d/%d", flowerRecordForTheme, NUMBER_OF_REQUIRED_FLOWERS_TO_UNLOCK_NEXT_THEME];
		CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:flowersString charMapFile:@"numberImages-red-s.png" itemWidth:12 itemHeight:14 startCharMap:'/'] autorelease];
		[label setAnchorPoint:CGPointZero];
		[label setPosition:[_flowerLabelPosition position]];
		[self addChild:label];

		_menu = [CCMenu new];
		FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			[game replaceState:[LevelSelectMenuState stateWithTheme:theme]];
		} selectedBlock:nil unselectedBlock:nil] autorelease];
		[_menu addChild:menuItem];
		[self addChild:_menu];
#ifndef DEBUG
		if (locked)
		{
			[_menu setEnabled:FALSE];
		}
#endif
	}
	return self;
}

-(void) dealloc
{
	[_menu release];

	[super dealloc];
}

-(void) animateSprite:(CCSprite *)sprite animationNames:(NSArray *)animationNames
{
	NSMutableArray *animationActions = [NSMutableArray array];
	for (NSString *animationName in animationNames)
	{
		CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
		CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
		[animationActions addObject:animationAction];
	}
	[sprite setDisplayFrameWithAnimationName:[animationNames objectAtIndex:0] index:0];
	CCSequence *sequenceAction = [CCSequence actionWithArray:animationActions];
	CCRepeatForever *repeatForeverAction = [CCRepeatForever actionWithAction:sequenceAction];
	[sprite runAction:repeatForeverAction];
}

-(void) swaySprite:(CCSprite *)sprite speed:(float)speed
{
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y + 2.0f)]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y - 2.0f)]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	[sprite runAction:swayAction];
}

@end
