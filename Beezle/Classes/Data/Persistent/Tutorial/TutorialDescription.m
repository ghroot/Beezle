//
//  TutorialDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialDescription.h"
#import "TutorialTriggerDescription.h"

@implementation TutorialDescription

@synthesize id = _id;
@synthesize triggerDescription = _triggerDescription;

-(id) initWithId:(NSString *)id andTrigger:(TutorialTriggerDescription *)triggerDescription
{
	if (self = [super init])
	{
		_id = [id copy];
		_triggerDescription = [triggerDescription retain];
	}
	return self;
}

-(void) dealloc
{
	[_id release];
	[_triggerDescription release];

	[super dealloc];
}


@end
