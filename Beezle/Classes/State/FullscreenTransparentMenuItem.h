//
//  LevelThemeSelectMenuItem.h
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface FullscreenTransparentMenuItem : CCMenuItemSprite

-(id) initWithBlock:(void (^)(id))block width:(float)width;
-(id) initWithBlock:(void (^)(id))block;

@end
