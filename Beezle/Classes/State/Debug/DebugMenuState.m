//
//  DebugMenuState.m
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugMenuState.h"
#import "AppDelegate.h"
#import "EmailInfo.h"
#import "Game.h"
#import "LevelSender.h"
#import "PlayerInformation.h"
#import "TestAnimationsState.h"

@interface DebugMenuState()

-(void) createMenu;
-(void) sendEditedLevels:(id)sender;
-(void) sendLevelsRatings:(id)sender;
-(void) startTestAnimations:(id)sender;
-(void) toggleStats:(id)sender;
-(void) resetPlayerInformation:(id)sender;
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
	
	CCMenuItem *sendEditedLevelsMenuItem = [CCMenuItemFont itemWithString:@"Send Edited Levels" target:self selector:@selector(sendEditedLevels:)];
	[_menu addChild:sendEditedLevelsMenuItem];
	CCMenuItem *sendLevelRatingsMenuItem = [CCMenuItemFont itemWithString:@"Send Level Ratings" target:self selector:@selector(sendLevelsRatings:)];
	[_menu addChild:sendLevelRatingsMenuItem];
	CCMenuItem *testAnimationsMenuItem = [CCMenuItemFont itemWithString:@"Test animations" target:self selector:@selector(startTestAnimations:)];
	[_menu addChild:testAnimationsMenuItem];
    CCMenuItem *toggleStatsMenuItem = [CCMenuItemFont itemWithString:@"Toggle stats" target:self selector:@selector(toggleStats:)];
	[_menu addChild:toggleStatsMenuItem];
	CCMenuItem *resetInfoMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" target:self selector:@selector(resetPlayerInformation:)];
	[_menu addChild:resetInfoMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:24];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:20.0f];
	
	[self addChild:_menu];
}

-(void) sendEditedLevels:(id)sender
{
    [[LevelSender sharedSender] sendEditedLevels];
}

-(void) sendLevelsRatings:(id)sender
{
	EmailInfo *emailInfo = [[EmailInfo alloc] init];
	[emailInfo setSubject:@"Beezle Level Ratings"];
	[emailInfo setTo:@"marcus.lagerstrom@gmail.com"];
	
	// Message
	[emailInfo setMessage:@"Here are my level ratings! :)"];
	
	// Attachments
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Level-Ratings.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		NSString *errorString = nil;
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
		[emailInfo addAttachment:@"Level-Ratings.plist" data:data];
	}
	
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendEmail:emailInfo];
	[emailInfo release];
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
    [[PlayerInformation sharedInformation] reset];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
