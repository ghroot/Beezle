//
//  BubbleSprite.m
//  Beezle
//
//  Created by Marcus on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BubbleSprite.h"

@implementation BubbleSprite

-(id) initWithFrameName:(NSString *)frameName
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Bubble.plist"];
	if (self = [super initWithSpriteFrameName:frameName])
	{
		CCScaleTo *scaleAction = [CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:1.0f scale:1.0f]];
		CCCallBlock *startSwayAction = [CCCallBlock actionWithBlock:^{
			CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y + 2.0f)]];
			CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:1.0f position:CGPointMake([self position].x, [self position].y - 2.0f)]];
			CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
			[self runAction:swayAction];
		}];

		[self setScale:0.1f];
		[self runAction:[CCSequence actionOne:scaleAction two:startSwayAction]];
	}
	return self;
}

@end
