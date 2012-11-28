//
//  DebugMenuState.m
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugMenuState.h"
#import "ConfirmationState.h"
#import "Game.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelOrganizer.h"
#import "LevelRatings.h"
#import "LevelSender.h"
#import "PlayerInformation.h"
#import "TestMenuState.h"
#import "PlayState.h"
#import "OutputConsoleState.h"

@interface DebugMenuState()

-(void) createMenu;
-(void) sendEditedLevels:(id)sender;
-(void) sendLevelRatings:(id)sender;
-(void) showTestMenu:(id)sender;
-(void) toggleStats:(id)sender;
-(void) resetPlayerInformation:(id)sender;
-(void) resetLevelRatings:(id)sender;
-(void) resetEditedLevels:(id)sender;
-(void) resaveEditedLevels:(id)sender;
-(void) showOutput:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation DebugMenuState

-(void) initialise
{
	[super initialise];
	
    [self createMenu];
}

-(void) createMenu
{
    _menu = [CCMenu menuWithItems:nil];
	
	CCMenuItemFont *sendEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Send Edited Levels" target:self selector:@selector(sendEditedLevels:)];
	[_menu addChild:sendEditedLevelsMenuItem];
	CCMenuItemFont *sendLevelRatingsMenuItem = [CCMenuItemFont itemWithString:@"Send Level Ratings" target:self selector:@selector(sendLevelRatings:)];
	[_menu addChild:sendLevelRatingsMenuItem];
	CCMenuItemFont *testMenuItem = [CCMenuItemFont itemWithString:@"Test" target:self selector:@selector(showTestMenu:)];
	[testMenuItem setFontSize:20];
	[_menu addChild:testMenuItem];
    CCMenuItemFont *toggleStatsMenuItem = [CCMenuItemFont itemWithString:@"Toggle stats" target:self selector:@selector(toggleStats:)];
	[toggleStatsMenuItem setFontSize:20];
	[_menu addChild:toggleStatsMenuItem];
	CCMenuItemFont *resetInfoMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" target:self selector:@selector(resetPlayerInformation:)];
	[resetInfoMenuItem setFontSize:20];
	[_menu addChild:resetInfoMenuItem];
	CCMenuItemFont *resetEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Reset edited levels" target:self selector:@selector(resetEditedLevels:)];
	[resetEditedLevelsMenuItem setFontSize:20];
	[_menu addChild:resetEditedLevelsMenuItem];
    CCMenuItemFont *resaveEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Resave edited levels" target:self selector:@selector(resaveEditedLevels:)];
	[resaveEditedLevelsMenuItem setFontSize:20];
	[_menu addChild:resaveEditedLevelsMenuItem];
	CCMenuItemFont *resetRatingsMenuItem = [CCMenuItemFont itemWithString:@"Reset level ratings" target:self selector:@selector(resetLevelRatings:)];
	[resetRatingsMenuItem setFontSize:20];
	[_menu addChild:resetRatingsMenuItem];
	CCMenuItemFont *outputMenuItem = [CCMenuItemFont itemWithString:@"Output" target:self selector:@selector(showOutput:)];
	[outputMenuItem setFontSize:20];
	[_menu addChild:outputMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:26];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:6.0f];
	
	[self addChild:_menu];

	NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString* appName = [infoDict objectForKey:@"CFBundleDisplayName"];
	NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
	NSString *labelString = [NSString stringWithFormat:@"%@ %@", appName, version];
	CCLabelTTF *versionLabel = [CCLabelTTF labelWithString:labelString fontName:@"Marker Felt" fontSize:12.0f];
	[versionLabel setAnchorPoint:CGPointZero];
	[self addChild:versionLabel];

	[[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
}

-(void) sendEditedLevels:(id)sender
{
    [[LevelSender sharedSender] sendEditedLevels];
}

-(void) sendLevelRatings:(id)sender
{
	[[LevelRatings sharedRatings] send];
}

-(void) showTestMenu:(id)sender
{
    [_game pushState:[TestMenuState state]];
}

-(void) toggleStats:(id)sender
{
    [[CCDirector sharedDirector] setDisplayStats:![[CCDirector sharedDirector] displayStats]];
}

-(void) resetPlayerInformation:(id)sender
{
	[_game pushState:[ConfirmationState stateWithTitle:@"Really reset player information?" block:^{
		[[PlayerInformation sharedInformation] reset];
	}]];
}

-(void) resetLevelRatings:(id)sender
{
	[_game pushState:[ConfirmationState stateWithTitle:@"Really reset level ratings?" block:^{
		[[LevelRatings sharedRatings] reset];
	}]];
}

-(void) resetEditedLevels:(id)sender
{
	[_game pushState:[ConfirmationState stateWithTitle:@"Really reset edited levels?" block:^{
		[[LevelLayoutCache sharedLevelLayoutCache] purgeAllCachedLevelLayouts];
		NSArray *allLevelNames = [[LevelOrganizer sharedOrganizer] allLevelNames];
		for (NSString *levelName in allLevelNames)
		{
			NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
		}
	}]];
}

-(void) resaveEditedLevels:(id)sender
{
    [_game pushState:[ConfirmationState stateWithTitle:@"Really resave edited levels?" block:^{
        NSArray *allLevelNames = [[LevelOrganizer sharedOrganizer] allLevelNames];
        for (NSString *levelName in allLevelNames)
        {
            LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
            if (levelLayout != nil)
            {
                // Update version
                [levelLayout setVersion:[levelLayout version] + 1];
                
                // Replace cached version of level layout
                [[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:levelLayout];
                
                // Save level as dictionary to a file
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
                BOOL success = [[levelLayout layoutAsDictionary] writeToFile:filePath atomically:TRUE];
                if (success)
                {
                    NSLog(@"%@v%i saved successfully!", levelName, [levelLayout version]);
                }
                else
                {
                    NSLog(@"%@ failed to save...", levelName);
                }
            }
        }
    }]];
}

-(void) showOutput:(id)sender
{
	[_game pushState:[OutputConsoleState state]];
}

-(void) goBack:(id)sender
{
	[_game replaceState:[PlayState state]];
}

@end
