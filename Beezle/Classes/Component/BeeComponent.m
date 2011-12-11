//
//  BeeComponent.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeComponent.h"

@implementation BeeComponent

@synthesize type = _type;

+(id) componentWithType:(BeeTypes *)type
{
	return [[[self alloc] initWithType:type] autorelease];
}

-(id) initWithType:(BeeTypes *)type
{
	if (self = [super init])
	{
		_type = type;
	}
	return self;
}

@end
