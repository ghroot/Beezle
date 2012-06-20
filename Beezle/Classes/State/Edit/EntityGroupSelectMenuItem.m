//
//  EntityGroupSelectMenuItem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityGroupSelectMenuItem.h"

@implementation EntityGroupSelectMenuItem

@synthesize entityTypes = _entityTypes;

-(id) initWithGroupName:(NSString *)groupName andEntityTypes:(NSArray *)entityTypes target:(id)target selector:(SEL)selector
{
	if (self = [super initWithString:groupName target:target selector:selector])
	{
		_entityTypes = [entityTypes retain];
	}
	return self;
}

-(void) dealloc
{
	[_entityTypes release];

	[super dealloc];
}

@end
