//
//  BeesFrontNode
//  Beezle
//
//  Created by marcus on 30/09/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeesFrontNode.h"
#import "ActionUtils.h"

@interface BeesFrontNode()

-(void) animateSprite:(CCSprite *)sprite animationNames:(NSArray *)animationNames;

@end

@implementation BeesFrontNode

-(id) init
{
	if (self = [super init])
	{
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"Chooser-Animations.plist"];

		CCSprite *saweeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[saweeSprite setPosition:CGPointMake(50.0f, 80.0f)];
		[self animateSprite:saweeSprite animationNames:[NSArray arrayWithObject:@"Chooser-Sawee-Idle"]];
		[ActionUtils swaySprite:saweeSprite speed:1.5f distance:2.0f];
		[self addChild:saweeSprite];

		CCSprite *bombeeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[bombeeSprite setPosition:CGPointMake(100.0f, 60.0f)];
		[self animateSprite:bombeeSprite animationNames:[NSArray arrayWithObjects:
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Idle",
				@"Chooser-Bombee-Blink",
				nil
		]];
		[ActionUtils swaySprite:bombeeSprite speed:0.9f distance:2.0f];
		[self addChild:bombeeSprite];

		CGSize winSize = [[CCDirector sharedDirector] winSize];

		CCSprite *speedeeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[speedeeSprite setPosition:CGPointMake(winSize.width - 170.0f, 80.0f)];
		[self animateSprite:speedeeSprite animationNames:[NSArray arrayWithObjects:
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Idle",
				@"Chooser-Speedee-Blink",
				nil
		]];
		[ActionUtils swaySprite:speedeeSprite speed:0.6f distance:2.0f];
		[self addChild:speedeeSprite];

		CCSprite *beeSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[beeSprite setPosition:CGPointMake(winSize.width - 130.0f, 80.0f)];
		[self animateSprite:beeSprite animationNames:[NSArray arrayWithObjects:
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Idle",
				@"Chooser-Bee-Blink",
				nil
		]];
		[ActionUtils swaySprite:beeSprite speed:1.1f distance:2.0f];
		[self addChild:beeSprite];

		CCSprite *beeaterSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Interface.png"]];
		[beeaterSprite setPosition:CGPointMake(winSize.width - 60.0f, 50.0f)];
		[self animateSprite:beeaterSprite animationNames:[NSArray arrayWithObjects:
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Idle",
				@"Chooser-Beeater-Lick",
				nil
		]];
		[self addChild:beeaterSprite];
	}
	return self;
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

@end