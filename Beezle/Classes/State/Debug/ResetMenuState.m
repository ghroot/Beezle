//
//  ResetMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/06/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ResetMenuState.h"
#import "PlayerInformation.h"
#import "ConfirmationState.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "LevelLayoutCache.h"
#import "LevelRatings.h"
#import "PlayState.h"

@interface ResetMenuState()

-(void) createMenu;

@end

@implementation ResetMenuState

-(void) initialise
{
	[super initialise];

	[self createMenu];
}

-(void) createMenu
{
	_menu = [CCMenu menuWithItems:nil];

	CCMenuItemFont *resetInfoMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" block:^(id sender){
		[_game pushState:[ConfirmationState stateWithTitle:@"Really reset player information?" block:^{
			[[PlayerInformation sharedInformation] reset];
		}]];
	}];
	[_menu addChild:resetInfoMenuItem];

	CCMenuItemFont *resetEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Reset edited levels" block:^(id sender){
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
	}];
	[_menu addChild:resetEditedLevelsMenuItem];

	CCMenuItemFont *resetRatingsMenuItem = [CCMenuItemFont itemWithString:@"Reset level ratings" block:^(id sender){
		[_game pushState:[ConfirmationState stateWithTitle:@"Really reset level ratings?" block:^{
			[[LevelRatings sharedRatings] reset];
		}]];
	}];
	[_menu addChild:resetRatingsMenuItem];

	CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
		[_game popState];
	}];
	[_menu addChild:backMenuItem];

	[_menu alignItemsVertically];

	[self addChild:_menu];
}

@end
