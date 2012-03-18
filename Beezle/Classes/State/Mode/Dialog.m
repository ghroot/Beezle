//
//  Dialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"
#import "CoverLayer.h"

@implementation Dialog

-(id) init
{
	if (self = [super init])
	{
		[self addChild:[CoverLayer node]];
	}
	return self;
}

@end
