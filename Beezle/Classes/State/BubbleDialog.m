//
//  BubbleDialog.m
//  Beezle
//
//  Created by Marcus on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BubbleDialog.h"
#import "Utils.h"

@interface BubbleDialog()

-(CCSprite *) createBubbleSprite:(NSString *)frameName;

@end

@implementation BubbleDialog

-(id) initWithFrameName:(NSString *)frameName
{
	if (self = [super initWithNode:[self createBubbleSprite:frameName]])
	{
		CCScaleTo *scaleAction = [CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:1.0f scale:1.0f]];
		CCCallBlock *startSwayAction = [CCCallBlock actionWithBlock:^{
			CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y + 2.0f)]];
			CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y - 2.0f)]];
			CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
			[self runAction:swayAction];
		}];

		[_node setScale:0.1f];
		[_node runAction:[CCSequence actionOne:scaleAction two:startSwayAction]];
	}
	return self;
}

-(CCSprite *) createBubbleSprite:(NSString *)frameName
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Bubble.plist"];
	CCSprite *bubbleSprite = [CCSprite spriteWithSpriteFrameName:frameName];
	[bubbleSprite setPosition:[Utils screenCenterPosition]];
	return bubbleSprite;
}

@end
