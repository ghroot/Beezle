//
//  TutorialEntityTypeTriggerDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialEntityTypeTriggerDescription.h"

@implementation TutorialEntityTypeTriggerDescription

@synthesize entityType = _entityType;

-(id) initWithEntityType:(NSString *)entityType
{
	if (self = [super init])
	{
		_entityType = [entityType copy];
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];

	[super dealloc];
}


@end
