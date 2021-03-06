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
#import "Utils.h"
#import "LiteUtils.h"

@interface LevelThemeSelectLayer()

-(void) animateSprite:(CCSprite *)sprite animationNames:(NSArray *)animationNames;
-(void) swaySprite:(CCSprite *)sprite speed:(float)speed;

@end

@implementation LevelThemeSelectLayer

+(id) layerWithTheme:(NSString *)theme game:(Game *)game
{
	return [[[self alloc] initWithTheme:theme game:game] autorelease];
}

-(id) initWithTheme:(NSString *)theme game:(Game *)game
{
	if (self = [super init])
	{
		_theme = [theme copy];

#ifdef LITE_VERSION
		NSString *interfaceFileName = [NSString stringWithFormat:@"ThemeSelect-%@-Lite.ccbi", theme];
#else
		NSString *interfaceFileName = [NSString stringWithFormat:@"ThemeSelect-%@.ccbi", theme];
#endif
		[self addChild:[CCBReader nodeGraphFromFile:interfaceFileName owner:self]];

		BOOL locked = ![[PlayerInformation sharedInformation] canPlayTheme:theme];

		[_lockSprite setVisible:locked];
		[_playSprite setVisible:!locked];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Chooser-Animations.plist"];

		NSMutableArray *animationNames = [NSMutableArray array];
		if ([theme isEqualToString:@"A"] ||
				[theme isEqualToString:@"E"])
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

		float universalScreenStartX = [Utils universalScreenStartX];

		CCSprite *beeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[beeSprite setPosition:CGPointMake(universalScreenStartX + 290.0f, 180.0f)];
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
		[beeBackSprite setPosition:CGPointMake(universalScreenStartX + 180.0f, 140.0f)];
		[self animateSprite:beeBackSprite animationNames:[NSArray arrayWithObject:@"Title-BeeBack-Idle"]];
		rotateRightAction = [CCRotateTo actionWithDuration:0.6f angle:3.0f];
		rotateLeftAction = [CCRotateTo actionWithDuration:0.6f angle:-3.0f];
		[beeBackSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:rotateRightAction two:rotateLeftAction]]];
		[self addChild:beeBackSprite];

		int totalNumberOfFlowers = [[PlayerInformation sharedInformation] totalNumberOfFlowers];
		int requiredNumberOfFlowers = [[LevelOrganizer sharedOrganizer] requiredNumberOfFlowersForTheme:theme];
		if (requiredNumberOfFlowers >= 0)
		{
			NSString *flowersString;
			if (requiredNumberOfFlowers > 0)
			{
				flowersString = [NSString stringWithFormat:@"%d/%d", totalNumberOfFlowers, requiredNumberOfFlowers];
			}
			else
			{
				flowersString = [NSString stringWithFormat:@"%d", totalNumberOfFlowers];
			}
			CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:flowersString charMapFile:@"numberImages-red-s.png" itemWidth:12 itemHeight:14 startCharMap:'/'] autorelease];
			[label setAnchorPoint:CGPointMake(0.0f, 0.5f)];
			[label setPosition:CGPointMake([_flowerSprite position].x + 5.0f, [_flowerSprite position].y)];
			[self addChild:label];
			if (requiredNumberOfFlowers == 0)
			{
				[_flowerSprite setPosition:CGPointMake([_flowerSprite position].x + 20.0f, [_flowerSprite position].y)];
				[label setPosition:CGPointMake([label position].x + 20.0f, [label position].y)];
			}
		}
		else
		{
			[_flowerSprite setVisible:FALSE];
		}

		_menu = [CCMenu new];
		[self addChild:_menu];

		BOOL canEnterLevelSelect;
#ifdef DEBUG
		canEnterLevelSelect = TRUE;
#else
		canEnterLevelSelect = !locked;
#endif
		if (canEnterLevelSelect)
		{
			FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
				[game replaceState:[LevelSelectMenuState stateWithTheme:theme]];
			} width:200.0f] autorelease];
			[_menu addChild:menuItem];
		}
	}
	return self;
}

-(void) dealloc
{
	[_theme release];
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

-(void) enable
{
#ifdef DEBUG
	[_menu setEnabled:TRUE];
#else
#ifdef LITE_VERSION
	[_menu setEnabled:TRUE];
#else
	BOOL locked = ![[PlayerInformation sharedInformation] canPlayTheme:_theme];
	if (!locked)
	{
		[_menu setEnabled:TRUE];
	}
#endif
#endif
}

-(void) disable
{
	[_menu setEnabled:FALSE];
}

@end
