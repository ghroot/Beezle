//
//  EmailInfo.m
//  Beezle
//
//  Created by Me on 26/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EmailInfo.h"

@implementation EmailInfo

@synthesize subject = _subject;
@synthesize to = _to;
@synthesize message = _message;
@synthesize attachmentsByFileName = _attachmentsByFileName;

-(id) init
{
	if (self = [super init])
	{
		_attachmentsByFileName = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[_subject release];
	[_to release];
	[_message release];
	[_attachmentsByFileName release];
	
	[super dealloc];
}

-(void) addAttachment:(NSString *)fileName data:(NSData *)data
{
	[_attachmentsByFileName setObject:data forKey:fileName];
}

@end
