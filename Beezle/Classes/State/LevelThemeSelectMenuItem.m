//
//  LevelThemeSelectMenuItem.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectMenuItem.h"

@implementation LevelThemeSelectMenuItem

@synthesize theme = _theme;

+(id) itemWithTheme:(NSString *)theme target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithTheme:theme target:target selector:selector] autorelease];
}

-(id) initWithTheme:(NSString *)theme target:(id)target selector:(SEL)selector
{
	if (self = [super initWithString:theme target:target selector:selector])
	{
		_theme = [theme copy];
		[self setFontSize:40];
	}
	return self;
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

@end
