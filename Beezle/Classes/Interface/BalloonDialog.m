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

		CCMenu *menu = [CCMenu node];
		CCMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			if (!_balloonCanBeClosed)
			{
				return;
			}

			CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTextureFilename:@"BubbleBurst-1.png" rect:CGRectMake(0.0f, 0.0f, 703.0f, 564.0f)];
			CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTextureFilename:@"BubbleBurst-2.png" rect:CGRectMake(0.0f, 0.0f, 703.0f, 564.0f)];
			CCSpriteFrame *frame3 = [CCSpriteFrame frameWithTextureFilename:@"BubbleBurst-3.png" rect:CGRectMake(0.0f, 0.0f, 703.0f, 564.0f)];
			NSArray *spriteFrames = [NSArray arrayWithObjects:frame1, frame2, frame3, nil];
			CCAnimation *burstAnimation = [CCAnimation animationWithSpriteFrames:spriteFrames delay:0.08f];
			CCAnimate *animationAction = [CCAnimate actionWithAnimation:burstAnimation];
			CCSprite *burstSprite = [CCSprite spriteWithSpriteFrame:frame1];
			CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
				[burstSprite removeFromParentAndCleanup:TRUE];
			}];
			[burstSprite setPosition:[Utils screenCenterPosition]];
			[parent_ addChild:burstSprite];
			[burstSprite runAction:[CCSequence actionOne:animationAction two:removeAction]];

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
