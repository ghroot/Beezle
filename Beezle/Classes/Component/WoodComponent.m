//
//  WoodComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoodComponent.h"

@implementation WoodComponent

@synthesize shapeIndexAtSawCollision = _shapeIndexAtSawCollision;

-(id) init
{
	if (self = [super init])
	{
		_shapeIndexAtSawCollision = -1;
	}
	return self;
}

@end
