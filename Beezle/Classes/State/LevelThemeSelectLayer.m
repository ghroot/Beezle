//
//  LevelThemeSelectLayer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectLayer.h"
#import "Utils.h"

@implementation LevelThemeSelectLayer

-(id) initWithTheme:(NSString *)theme block:(void(^)(id sender))block
{
	if (self = [super init])
	{
		CCMenu *menu = [CCMenu node];

		NSString *globeImageFile = [NSString stringWithFormat:@"Globe-%@.png", theme];
		CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalImage:globeImageFile selectedImage:globeImageFile block:block];
		[menuItem setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[menu addChild:menuItem];
		[self addChild:menu];

		NSString *titleImageFile = [NSString stringWithFormat:@"Title-%@.png", theme];
		CCSprite *titleSprite = [CCSprite spriteWithFile:titleImageFile];
		[titleSprite setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[titleSprite setPosition:[Utils getScreenCenterPosition]];
		[self addChild:titleSprite];
	}
	return self;
}

@end
