//
//  LevelMenuItem.m
//  Beezle
//
//  Created by KM Lagerstrom on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuItem.h"

@implementation LevelSelectMenuItem

@synthesize levelName = _levelName;

+(id) itemWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithLevelName:levelName target:target selector:selector] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector
{
	NSString *shortLevelName = [levelName stringByReplacingOccurrencesOfString:@"Level-" withString:@""];
	if (self = [super initWithString:shortLevelName target:target selector:selector])
	{
		_levelName = [levelName copy];
		[self setFontSize:24];
	}
	return self;
}

-(void) dealloc
{
	[_levelName release];
	
	[super dealloc];
}

@end
