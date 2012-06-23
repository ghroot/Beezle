//
//  LevelThemeSelectLayer.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LevelThemeSelectLayer : CCLayer

-(id) initWithTheme:(NSString *)theme block:(void(^)(id sender))block;

@end
