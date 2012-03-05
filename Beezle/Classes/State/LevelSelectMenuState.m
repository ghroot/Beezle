//
//  LevelSelectMenuState.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelOrganizer.h"
#import "PlayerInformation.h"

@implementation LevelSelectMenuState

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme
{
	return [[[self alloc] initWithTheme:theme] autorelease];
}

// Designated initialiser
-(id) initWithTheme:(NSString *)theme
{
    if (self = [super init])
    {
		_theme = [theme retain];
    }
    return self;
}

-(id) init
{
	return [self initWithTheme:nil];
}

-(void) initialise
{
	[super initialise];
	
	[[CCDirector sharedDirector] setNeedClear:TRUE];
	
	_menu = [CCMenu menuWithItems:nil];
	
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesInTheme:_theme];
	for (NSString *levelName in levelNames)
	{
		NSString *shortLevelName = [levelName stringByReplacingOccurrencesOfString:@"Level-" withString:@""];
		NSString *menuItemName = nil;
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		if (levelLayout != nil)
		{
			menuItemName = [NSString stringWithFormat:@"%@(%d)%@", shortLevelName, [levelLayout version], [levelLayout isEdited] ? @"e" : @""];
		}
		else
		{
			menuItemName = shortLevelName;
		}
		CCMenuItemFont *levelMenuItem = [CCMenuItemFont itemWithString:menuItemName target:self selector:@selector(startGame:)];
		[levelMenuItem setFontSize:24];
		[levelMenuItem setUserData:levelName];
		[_menu addChild:levelMenuItem];
        
        if (!CONFIG_CAN_EDIT_LEVELS)
        {
            if (![[PlayerInformation sharedInformation] canPlayLevel:levelName])
            {
                [levelMenuItem setIsEnabled:FALSE];
            }
        }
	}
	CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
	[backMenuItem setFontSize:24];
	[_menu addChild:backMenuItem];
	
	int nRows = 9;
	int n1 = (int)([levelNames count] / nRows) + 1;
	int n2 = [levelNames count] - (nRows - 1) * n1;
	[_menu alignItemsInColumns:
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n2],
		[NSNumber numberWithInt:1],
		nil];
	
	[self addChild:_menu];
	
	for (NSString *levelName in levelNames)
	{
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		NSString *string = nil;
		if (levelLayout != nil)
		{
			string = [NSString stringWithFormat:@"%@v%i (%@)", levelName, [levelLayout version], ([levelLayout isEdited] ? @"edited" : @"original")];
		}
		else
		{
			string = [NSString stringWithFormat:@"%@ (%@)", levelName, @"n/a"];
		}
		NSLog(@"%@", string);
	}
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

-(void) startGame:(id)sender
{
    NSString *levelName = (NSString *)[sender userData];
	[_game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
