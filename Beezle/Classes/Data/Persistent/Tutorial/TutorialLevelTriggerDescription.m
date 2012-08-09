//
//  TutorialLevelTriggerDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialLevelTriggerDescription.h"

@implementation TutorialLevelTriggerDescription

@synthesize levelName = _levelName;

-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
	{
		_levelName = [levelName copy];
	}
	return self;
}

-(void) dealloc
{
	[_levelName release];

	[super dealloc];
}


@end
