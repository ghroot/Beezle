//
//  LevelThemeSelectLayer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectLayer.h"

@implementation LevelThemeSelectLayer

-(id) initWithTheme:(NSString *)theme block:(void(^)(id sender))block
{
	if (self = [super init])
	{
		CCMenu *menu = [CCMenu node];

		NSString *imageFile = [NSString stringWithFormat:@"Theme chooser %@.jpg", theme];
		CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalImage:imageFile selectedImage:imageFile block:block];
		[menuItem setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[menu addChild:menuItem];

		[self addChild:menu];
	}
	return self;
}

@end
