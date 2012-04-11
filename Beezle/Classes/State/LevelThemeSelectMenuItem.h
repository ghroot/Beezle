//
//  LevelThemeSelectMenuItem.h
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMenuItem.h"

@interface LevelThemeSelectMenuItem : CCMenuItemFont
{
	NSString *_theme;
}

@property (nonatomic, readonly) NSString *theme;

+(id) itemWithTheme:(NSString *)theme target:(id)target selector:(SEL)selector;

-(id) initWithTheme:(NSString *)theme target:(id)target selector:(SEL)selector;

@end
