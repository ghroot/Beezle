//
//  TutorialBeeTypeTriggerDescription.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialBeeTypeTriggerDescription.h"
#import "BeeType.h"

@implementation TutorialBeeTypeTriggerDescription

@synthesize beeType = _beeType;

-(id) initWithBeeType:(BeeType *)beeType
{
	if (self = [super init])
	{
		_beeType = beeType;
	}
	return self;
}

@end
