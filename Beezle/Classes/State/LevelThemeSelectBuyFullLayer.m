//
//  LevelThemeSelectBuyFullLayer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectBuyFullLayer.h"
#import "CCBReader.h"
#import "ActionUtils.h"
#import "FullscreenTransparentMenuItem.h"
#import "LiteUtils.h"
#import "SessionTracker.h"

@implementation LevelThemeSelectBuyFullLayer

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CCBReader nodeGraphFromFile:@"ThemeSelectBuyFull.ccbi" owner:self]];

		[ActionUtils swaySprite:_beeSprite1 speed:1.5f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite1 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Speedee-1.png", @"End-GameCompleted!-Speedee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite2 speed:1.1f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite2 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sumee-1.png", @"End-GameCompleted!-Sumee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite3 speed:0.6f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite3 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bombee-1.png", @"End-GameCompleted!-Bombee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite4 speed:1.2f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite4 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bee-1.png", @"End-GameCompleted!-Bee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite5 speed:0.8f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite5 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-TBee-1.png", @"End-GameCompleted!-TBee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite6 speed:0.9f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite6 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sawee-1.png", @"End-GameCompleted!-Sawee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite7 speed:1.0f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite7 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Mumee-1.png", @"End-GameCompleted!-Mumee-2.png", nil] delay:0.1f];

		CCMenu *menu = [CCMenu node];
		FullscreenTransparentMenuItem *menuItem = [[[FullscreenTransparentMenuItem alloc] initWithBlock:^(id sender){
			[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"buy full world"];
			[[LiteUtils sharedUtils] showBuyFullVersionAlert];
		} width:200.0f] autorelease];
		[menu addChild:menuItem];
		[self addChild:menu];
	}
	return self;
}

@end
