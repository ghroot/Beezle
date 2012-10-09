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

-(CCSprite *) createBubbleSprite:(NSString *)fileName;

@end

@implementation BalloonDialog

-(id) initWithFileName:(NSString *)fileName
{
	if (self = [super initWithNode:[self createBubbleSprite:fileName]])
	{
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];

		_balloonCanBeClosed = FALSE;

		CCScaleTo *scaleAction = [CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:0.8f scale:1.0f]];
		CCCallBlock *startSwayAction = [CCCallBlock actionWithBlock:^{
			CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_node position].x, [_node position].y + 2.0f)]];
			CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([_node position].x, [_node position].y - 2.0f)]];
			CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
			[_node runAction:swayAction];
		}];
		CCCallBlock *enableMenuAction = [CCCallBlock actionWithBlock:^{
			_balloonCanBeClosed = TRUE;
		}];

		[_node setScale:0.1f];
		[_node runAction:[CCSequence actions:scaleAction, startSwayAction, enableMenuAction, nil]];
		[[SoundManager sharedManager] playSound:@"BlowUpBalloon"];

		CCMenu *menu = [CCMenu node];
		CCMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			if (!_balloonCanBeClosed)
			{
				return;
			}

			[self close];

			[[SoundManager sharedManager] playSound:@"BalloonBurst"];

		} selectedBlock:nil unselectedBlock:nil] autorelease];
		[menu addChild:menuItem];
		[self addChild:menu];
	}
	return self;
}

-(CCSprite *) createBubbleSprite:(NSString *)fileName
{
	CCSprite *bubbleSprite = [CCSprite spriteWithFile:fileName];
	[bubbleSprite setPosition:[Utils screenCenterPosition]];
	return bubbleSprite;
}

@end
