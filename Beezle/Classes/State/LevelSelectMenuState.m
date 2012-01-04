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
		
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
        _menu = [CCMenu menuWithItems:nil];
		
		NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesForTheme:theme];
        for (NSString *levelName in levelNames)
        {
            CCMenuItem *levelMenuItem = [CCMenuItemFont itemFromString:levelName target:self selector:@selector(startGame:)];
            [levelMenuItem setUserData:levelName];
            [_menu addChild:levelMenuItem];
        }
		CCMenuItem *backMenuItem = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(goBack:)];
		[_menu addChild:backMenuItem];
		
        [_menu alignItemsVertically];
        
        [self addChild:_menu];
		
		for (NSString *levelName in levelNames)
		{
			LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
			NSString *string = [NSString stringWithFormat:@"%@v%i (%@)", levelName, [levelLayout version], ([levelLayout isEdited] ? @"edited" : @"original")];
			NSLog(@"%@", string);
		}
    }
    return self;
}

-(id) init
{
	return [self initWithTheme:nil];
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

-(void) startGame:(id)sender
{
	// This assumes the previous state was the menu state
    NSString *levelName = (NSString *)[sender userData];
	[_game popAndReplaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
