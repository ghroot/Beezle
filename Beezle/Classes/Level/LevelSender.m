//
//  LevelSender.m
//  Beezle
//
//  Created by Me on 03/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSender.h"
#import "AppDelegate.h"
#import "EmailInfo.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelOrganizer.h"

#define EMAIL_SUBJECT @"Beezle Levels"
#define EMAIL_ADDRESS @"marcus.lagerstrom@gmail.com"

@implementation LevelSender

+(LevelSender *) sharedSender
{
    static LevelSender *sender = 0;
    if (!sender)
    {
        sender = [[self alloc] init];
    }
    return sender;
}

-(void) sendEditedLevels
{
	EmailInfo *emailInfo = [[EmailInfo alloc] init];
	[emailInfo setSubject:EMAIL_SUBJECT];
	[emailInfo setTo:EMAIL_ADDRESS];
	
	// Message
	NSMutableString *message = [NSMutableString string];
	
	// Attachments
	NSArray *levelLayouts = [[LevelLayoutCache sharedLevelLayoutCache] allLevelLayouts];
	for (LevelLayout *levelLayout in levelLayouts)
	{
		if ([levelLayout isEdited])
		{
			NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", [levelLayout levelName]];
			NSString *errorString = nil;
			NSData *data = [NSPropertyListSerialization dataFromPropertyList:[levelLayout layoutAsDictionary] format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
			[emailInfo addAttachment:levelFileName data:data];
			
			[message appendString:[NSString stringWithFormat:@"%@v%i", [levelLayout levelName], [levelLayout version]]];
			[message appendString:@"\n"];
		}
	}
	
	[emailInfo setMessage:message];
	
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendEmail:emailInfo];
	[emailInfo release];
}

@end
