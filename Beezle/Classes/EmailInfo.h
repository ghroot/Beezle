//
//  EmailInfo.h
//  Beezle
//
//  Created by Me on 26/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface EmailInfo : NSObject
{
	NSString *_subject;
	NSString *_to;
	NSString *_message;
	NSMutableDictionary *_attachmentsByFileName;
}

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *to;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, readonly) NSDictionary *attachmentsByFileName;

-(void) addAttachment:(NSString *)fileName data:(NSData *)data;

@end
