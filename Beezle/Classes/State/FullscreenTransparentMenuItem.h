//
//  LevelThemeSelectMenuItem.h
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface FullscreenTransparentMenuItem : CCMenuItemSprite
{
	void (^_selectedBlock)(id sender);
	void (^_unselectedBlock)(id sender);
}

-(id) initWithBlock:(void (^)(id))block selectedBlock:(void (^)(id))selectedBlock unselectedBlock:(void (^)(id))unselectedBlock;

@end
