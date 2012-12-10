//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "RespawnComponent.h"

@implementation RespawnComponent

@synthesize entityType = _entityType;
@synthesize respawnAnimationName = _respawnAnimationName;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_entityType = [[typeComponentDict objectForKey:@"entityType"] copy];
		_respawnAnimationName = [[typeComponentDict objectForKey:@"respawnAnimation"] copy];
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];
	[_respawnAnimationName release];

	[super dealloc];
}

@end
