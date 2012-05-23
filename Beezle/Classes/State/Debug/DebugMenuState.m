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
#import "TestAnimationsState.h"

@interface DebugMenuState()

-(void) createMenu;
-(void) sendEditedLevels:(id)sender;
-(void) sendLevelRatings:(id)sender;
-(void) startTestAnimations:(id)sender;
-(void) toggleStats:(id)sender;
-(void) resetPlayerInformation:(id)sender;
-(void) resetLevelRatings:(id)sender;
-(void) resetEditedLevels:(id)sender;
-(void) resaveEditedLevels:(id)sender;
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
	CCMenuItemFont *testAnimationsMenuItem = [CCMenuItemFont itemWithString:@"Test animations" target:self selector:@selector(startTestAnimations:)];
	[_menu addChild:testAnimationsMenuItem];
    CCMenuItemFont *toggleStatsMenuItem = [CCMenuItemFont itemWithString:@"Toggle stats" target:self selector:@selector(toggleStats:)];
	[_menu addChild:toggleStatsMenuItem];
	CCMenuItemFont *resetInfoMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" target:self selector:@selector(resetPlayerInformation:)];
	[resetInfoMenuItem setFontSize:20.0f];
	[_menu addChild:resetInfoMenuItem];
	CCMenuItemFont *resetEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Reset edited levels" target:self selector:@selector(resetEditedLevels:)];
	[resetEditedLevelsMenuItem setFontSize:20.0f];
	[_menu addChild:resetEditedLevelsMenuItem];
    CCMenuItemFont *resaveEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Resave edited levels" target:self selector:@selector(resaveEditedLevels:)];
	[resaveEditedLevelsMenuItem setFontSize:20.0f];
	[_menu addChild:resaveEditedLevelsMenuItem];
	CCMenuItemFont *resetRatingsMenuItem = [CCMenuItemFont itemWithString:@"Reset level ratings" target:self selector:@selector(resetLevelRatings:)];
	[resetRatingsMenuItem setFontSize:20.0f];
	[_menu addChild:resetRatingsMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:26.0f];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:6.0f];
	
	[self addChild:_menu];
}

-(void) sendEditedLevels:(id)sender
{
    [[LevelSender sharedSender] sendEditedLevels];
}

-(void) sendLevelRatings:(id)sender
{
	[[LevelRatings sharedRatings] send];
}

-(void) startTestAnimations:(id)sender
{
    [_game replaceState:[TestAnimationsState state]];
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

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
