//
//  EntitySelectMenuItem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySelectMenuItem.h"

@implementation EntitySelectMenuItem

@synthesize entityType = _entityType;

-(id) initWithEntityType:(NSString *)entityType target:(id)target selector:(SEL)selector
{
	if (self = [super initWithString:entityType target:target selector:selector])
	{
		_entityType = [entityType retain];
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];

	[super dealloc];
}

@end
