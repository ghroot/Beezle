//
//  TutorialBalloonDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialBalloonDescription.h"

@implementation TutorialBalloonDescription

@synthesize fileName = _fileName;
@synthesize offset = _offset;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFileName:(NSString *)fileName andOffset:(CGPoint)offset
{
	if (self = [super initWithId:id andTrigger:triggerDescription])
	{
		_fileName = [fileName copy];
		_offset = offset;
	}
	return self;
}

-(void) dealloc
{
	[_fileName release];

	[super dealloc];
}


@end
