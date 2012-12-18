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
@synthesize buttonFileName = _buttonFileName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription fileName:(NSString *)fileName buttonFileName:(NSString *)buttonFileName
{
	if (self = [super initWithId:id andTrigger:triggerDescription])
	{
		_fileName = [fileName copy];
		_buttonFileName = [buttonFileName copy];
	}
	return self;
}

-(void) dealloc
{
	[_fileName release];
	[_buttonFileName release];

	[super dealloc];
}


@end
