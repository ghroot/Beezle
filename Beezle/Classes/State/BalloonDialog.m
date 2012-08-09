//
//  BalloonDialog.m
//  Beezle
//
//  Created by Marcus on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BalloonDialog.h"
#import "Utils.h"
#import "FullscreenTransparentMenuItem.h"
#import "SoundManager.h"

@interface BalloonDialog ()

-(CCSprite *) createBubbleSprite:(NSString *)frameName;

@end

@implementation BalloonDialog

-(id) initWithFrameName:(NSString *)frameName
{
	if (self = [super initWithNode:[self createBubbleSprite:frameName]])
	{
		CCScaleTo *scaleAction = [CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:0.8f scale:1.0f]];
		CCCallBlock *startSwayAction = [CCCallBlock actionWithBlock:^{
			CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y + 2.0f)]];
			CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y - 2.0f)]];
			CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
			[self runAction:swayAction];
		}];

		[_node setScale:0.1f];
		[_node runAction:[CCSequence actionOne:scaleAction two:startSwayAction]];
		[[SoundManager sharedManager] playSound:@"BlowUpBalloon"];

		CCMenu *menu = [CCMenu node];
		CCMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			NSArray *spriteFrames = [NSArray arrayWithObjects:
				[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Bubble/BubbleBurst-1.png"],
				[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Bubble/BubbleBurst-2.png"],
				[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Bubble/BubbleBurst-3.png"],
				nil];
			CCAnimation *animation = [CCAnimation animationWithSpriteFrames:spriteFrames delay:0.05f];
			CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
			CCCallBlock *closeAction = [CCCallBlock actionWithBlock:^{
				[self close];
			}];
			[_node runAction:[CCSequence actionOne:animateAction two:closeAction]];
			[[SoundManager sharedManager] playSound:@"BalloonBurst"];
		} selectedBlock:nil unselectedBlock:nil] autorelease];
		[menu addChild:menuItem];
		[self addChild:menu];
	}
	return self;
}

-(CCSprite *) createBubbleSprite:(NSString *)frameName
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
	CCSprite *bubbleSprite = [CCSprite spriteWithSpriteFrameName:frameName];
	[bubbleSprite setPosition:[Utils screenCenterPosition]];
	return bubbleSprite;
}

@end
