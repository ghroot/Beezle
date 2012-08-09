//
//  TutorialStripDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialStripDescription.h"

@implementation TutorialStripDescription

@synthesize fileName = _fileName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFileName:(NSString *)fileName
{
	if (self = [super initWithId:id andTrigger:triggerDescription])
	{
		_fileName = [fileName copy];
	}
	return self;
}

-(void) dealloc
{
	[_fileName release];

	[super dealloc];
}


@end
