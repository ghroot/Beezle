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
#import "LevelOrganizer.h"

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
	[emailInfo setSubject:@"Beezle Levels"];
	[emailInfo setTo:@"marcus.lagerstrom@gmail.com"];
	
	// Message
	NSMutableString *message = [NSMutableString string];
	
	// Attachments
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesForTheme:@"A"];
	for (NSString *levelName in levelNames)
	{
		NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		if (dict != nil)
		{
			NSString *errorString = nil;
			NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
			[emailInfo addAttachment:levelFileName data:data];
			
			[message appendString:[NSString stringWithFormat:@"%@v%i", levelName, 0]];
			[message appendString:@"\n"];
		}
	}
	
	[emailInfo setMessage:message];
	
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendEmail:emailInfo];
	[emailInfo release];
}

@end
