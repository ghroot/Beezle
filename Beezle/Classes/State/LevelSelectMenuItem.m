//
//  LevelMenuItem.m
//  Beezle
//
//  Created by KM Lagerstrom on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuItem.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"

@implementation LevelSelectMenuItem

@synthesize levelName = _levelName;

+(id) itemWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithLevelName:levelName target:target selector:selector] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName target:(id)target selector:(SEL)selector
{
	NSString *shortLevelName = [levelName stringByReplacingOccurrencesOfString:@"Level-" withString:@""];
#ifdef CONFIG_CAN_EDIT_LEVELS
    LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
    if (levelLayout != nil &&
        [levelLayout isEdited])
    {
        shortLevelName = [shortLevelName stringByAppendingString:@"e"];
    }
#endif
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
