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

-(id) initWithFileName:(NSString *)fileName andOffset:(CGPoint)offset
{
	if (self = [super initWithNode:[self createBubbleSprite:fileName] coverOpacity:80])
	{
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

		[_node setPosition:ccpAdd([Utils screenCenterPosition], offset)];
		[_node setScale:0.1f];
		[_node runAction:[CCSequence actions:scaleAction, startSwayAction, enableMenuAction, nil]];
		[[SoundManager sharedManager] playSound:@"BlowUpBalloon"];

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];

		CCMenu *menu = [CCMenu node];
		CCMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			if (!_balloonCanBeClosed)
			{
				return;
			}

			CGPoint centerPosition = [_node position];

			for (int i = 0; i < 6; i++)
			{
				float angle = CC_DEGREES_TO_RADIANS((360.0f / 6) * i);
				CGPoint startPosition = CGPointMake(centerPosition.x + 70.0f * cosf(angle), centerPosition.y + 70.0f * sinf(angle));
				CGPoint endPosition = CGPointMake(centerPosition.x + 180.0f * cosf(angle), centerPosition.y + 180.0f * sinf(angle));

				int randomPieceIndex = (rand() % 3) + 1;
				CCSprite *burstSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Bubble/BubbleBurst-pc%d.png", randomPieceIndex]];
				[burstSprite setPosition:startPosition];
				[burstSprite setScale:1.4f];

				float duration = 0.1f;
				CCMoveTo *moveAction = [CCMoveTo actionWithDuration:duration position:endPosition];
				CCFadeOut *fadeAction = [CCFadeOut actionWithDuration:duration];
				CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:duration angle:100.0f];
				CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:duration scale:0.2f];
				CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
					[burstSprite removeFromParentAndCleanup:TRUE];
				}];
				[burstSprite runAction:[CCSequence actionOne:moveAction two:removeAction]];
				[burstSprite runAction:fadeAction];
				[burstSprite runAction:rotateAction];
				[burstSprite runAction:scaleDownAction];

				[parent_ addChild:burstSprite];
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
