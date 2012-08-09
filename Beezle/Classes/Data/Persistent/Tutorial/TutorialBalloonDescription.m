//
//  TutorialBalloonDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialBalloonDescription.h"

@implementation TutorialBalloonDescription

@synthesize frameName = _frameName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFrameName:(NSString *)frameName
{
	if (self = [super initWithId:id andTrigger:triggerDescription])
	{
		_frameName = [frameName copy];
	}
	return self;
}

-(void) dealloc
{
	[_frameName release];

	[super dealloc];
}


@end
