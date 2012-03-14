//
//  LevelMenuItem.h
//  Beezle
//
//  Created by KM Lagerstrom on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LevelSelectMenuItem : CCMenuItemFont
{
	NSString *_levelName;
}

@property (nonatomic, readonly) NSString *levelName;

+(id) itemWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector;

-(id) initWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector;

@end
