//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "AppDelegate.h"
#import "EditState.h"
#import "EmailInfo.h"
#import "EmptyState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayoutCache.h"
#import "TestState.h"

@implementation MainMenuState

-(id) init
{
    if (self = [super init])
    {   
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
        _menu = [CCMenu menuWithItems:nil];
        
        NSArray *levelNames = [NSArray arrayWithObjects:
                               @"Level-A1",
                               @"Level-A2",
							   @"Level-A3",
                               @"Level-A5",
                               @"Level-A9",
                               nil];
        for (NSString *levelName in levelNames)
        {
            CCMenuItem *levelMenuItem = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Play %@", levelName] target:self selector:@selector(startGame:)];
            [levelMenuItem setUserData:levelName];
            [_menu addChild:levelMenuItem];
        }
        CCMenuItem *testMenuItem = [CCMenuItemFont itemFromString:@"Test" target:self selector:@selector(startTest:)];
        [_menu addChild:testMenuItem];
        
        [_menu alignItemsVerticallyWithPadding:20.0f];
        
        [self addChild:_menu];
    }
    return self;
}

-(void) startGame:(id)sender
{
    NSString *levelName = (NSString *)[sender userData];
	[_game replaceState:[GameplayState stateWithLevelName:levelName]];
	
//	EmailInfo *emailInfo = [[EmailInfo alloc] init];
//	[emailInfo setSubject:levelName];
//	[emailInfo setTo:@"marcus.lagerstrom@gmail.com"];
//	[emailInfo setMessage:@"Here is level A3 v12!"];

	// Attachment
//	NSString *path = [CCFileUtils fullPathFromRelativePath:levelFileName];
//	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//	NSString *errorString = nil;
//	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
//	[emailInfo addAttachment:levelFileName data:data];
	
//	[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendEmail:emailInfo];
//	[emailInfo release];
}

-(void) startTest:(id)sender
{
	[_game replaceState:[TestState state]];
}

@end
