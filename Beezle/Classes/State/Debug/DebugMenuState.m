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
#import "TestMenuState.h"
#import "PlayState.h"
#import "OutputConsoleState.h"
#import "ResetMenuState.h"

@interface DebugMenuState()

-(void) createMenu;
-(void) sendEditedLevels:(id)sender;
-(void) sendLevelRatings:(id)sender;
-(void) showTestMenu:(id)sender;
-(void) toggleStats:(id)sender;
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
	CCMenuItemFont *resetMenuItem = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[_game pushState:[ResetMenuState state]];
	}];
	[resetMenuItem setFontSize:20];
	[_menu addChild:resetMenuItem];
    CCMenuItemFont *resaveEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Resave edited levels" target:self selector:@selector(resaveEditedLevels:)];
	[resaveEditedLevelsMenuItem setFontSize:20];
	[_menu addChild:resaveEditedLevelsMenuItem];
	CCMenuItemFont *outputMenuItem = [CCMenuItemFont itemWithString:@"Output" target:self selector:@selector(showOutput:)];
	[_menu addChild:outputMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:26];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:6.0f];
	
	[self addChild:_menu];

	NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString* appName = [infoDict objectForKey:@"CFBundleName"];
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
