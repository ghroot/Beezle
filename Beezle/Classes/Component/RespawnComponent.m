//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "RespawnComponent.h"

@implementation RespawnComponent

@synthesize entityType = _entityType;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_entityType = [[typeComponentDict objectForKey:@"entityType"] copy];
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];

	[super dealloc];
}

@end
