//
// Created by Marcus on 10/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ActionUtils.h"
#import "CCSprite.h"
#import "CCActionInterval.h"
#import "CCActionEase.h"
#import "CCAnimation.h"
#import "CCSpriteFrame.h"
#import "ActionTags.h"

@implementation ActionUtils

+(void) swaySprite:(CCSprite *)sprite speed:(float)speed distance:(float)distance
{
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y + distance)]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y - distance)]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	[sprite runAction:swayAction];
}

+(void) animateSprite:(CCSprite *)sprite fileNames:(NSArray *)fileNames delay:(float)delay
{
	[sprite stopActionByTag:ACTION_TAG_ANIMATION];

	NSMutableArray *spriteFrames = [NSMutableArray array];
	for (NSString *fileName in fileNames)
	{
		CCSprite *sprite2 = [CCSprite spriteWithFile:fileName];
		CCSpriteFrame *spriteFrame = [CCSpriteFrame frameWithTextureFilename:fileName rect:CGRectMake(0.0f, 0.0f, [sprite2 contentSize].width, [sprite2 contentSize].height)];
		[spriteFrames addObject:spriteFrame];
	}

	CCAnimation *animation = [CCAnimation animationWithSpriteFrames:spriteFrames delay:delay];
	CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
	CCRepeatForever *repeatForeverAction = [CCRepeatForever actionWithAction:animationAction];
	[repeatForeverAction setTag:ACTION_TAG_ANIMATION];
	[sprite runAction:repeatForeverAction];
}

@end
