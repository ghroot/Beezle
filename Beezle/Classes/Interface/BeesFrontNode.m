//
//  BeesFrontNode
//  Beezle
//
//  Created by marcus on 30/09/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeesFrontNode.h"

@interface BeesFrontNode()

-(void) animateSprite:(CCSprite *)sprite animationName:(NSString *)animationName;
-(void) swaySprite:(CCSprite *)sprite speed:(float)speed;

@end

@implementation BeesFrontNode

-(id) init
{
	if (self = [super init])
	{
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Interface-Animations.plist"];

		CCSprite *saweeSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Chooser-Sawee-1.png"];
		[saweeSprite setPosition:CGPointMake(50.0f, 80.0f)];
		[self animateSprite:saweeSprite animationName:@"Chooser-Sawee"];
		[self swaySprite:saweeSprite speed:1.5f];
		[self addChild:saweeSprite];

		CCSprite *bombeeSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Chooser-Bombee-1.png"];
		[bombeeSprite setPosition:CGPointMake(100.0f, 60.0f)];
		[self animateSprite:bombeeSprite animationName:@"Chooser-Bombee"];
		[self swaySprite:bombeeSprite speed:0.9f];
		[self addChild:bombeeSprite];

		CCSprite *speedeeSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Chooser-Speedee-1.png"];
		[speedeeSprite setPosition:CGPointMake(310.0f, 80.0f)];
		[self animateSprite:speedeeSprite animationName:@"Chooser-Speedee"];
		[self swaySprite:speedeeSprite speed:0.6f];
		[self addChild:speedeeSprite];

		CCSprite *beeSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Chooser-Bee-1.png"];
		[beeSprite setPosition:CGPointMake(350.0f, 80.0f)];
		[self animateSprite:beeSprite animationName:@"Chooser-Bee"];
		[self swaySprite:beeSprite speed:1.1f];
		[self addChild:beeSprite];

		CCSprite *beeaterSprite = [CCSprite spriteWithSpriteFrameName:@"Chooser/Chooser-Beeater-1.png"];
		[beeaterSprite setPosition:CGPointMake(420.0f, 50.0f)];
		[self animateSprite:beeaterSprite animationName:@"Chooser-Beeater"];
		[self addChild:beeaterSprite];
	}
	return self;
}

-(void) animateSprite:(CCSprite *)sprite animationName:(NSString *)animationName
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCAnimate *animateActon = [CCAnimate actionWithAnimation:animation];
	[sprite runAction:[CCRepeatForever actionWithAction:animateActon]];
}

-(void) swaySprite:(CCSprite *)sprite speed:(float)speed
{
	CCMoveTo *moveUpAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y + 2.0f)]];
	CCMoveTo *moveDownAction = [CCEaseSineInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:CGPointMake([sprite position].x, [sprite position].y - 2.0f)]];
	CCAction *swayAction = [CCRepeat actionWithAction:[CCSequence actions:moveUpAction, moveDownAction, nil] times:INT_MAX];
	[sprite runAction:swayAction];
}

@end