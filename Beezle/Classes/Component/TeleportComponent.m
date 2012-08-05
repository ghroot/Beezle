//
//  TeleportComponent.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportComponent.h"
#import "TeleportInfo.h"

@implementation TeleportComponent

@synthesize outPosition = _outPosition;
@synthesize outRotation = _outRotation;
@synthesize teleportInfos = _teleportInfos;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Instance
		_outPosition = CGPointFromString([instanceComponentDict objectForKey:@"outPosition"]);
		_outRotation = [[instanceComponentDict objectForKey:@"outRotation"] floatValue];
	}
	return self;
}

-(id) init
{
	if (self = [super init])
	{
		_teleportInfos = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_teleportInfos release];

	[super dealloc];
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];

	[instanceComponentDict setObject:NSStringFromCGPoint(_outPosition) forKey:@"outPosition"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:_outRotation] forKey:@"outRotation"];

	return instanceComponentDict;
}

-(void) addTeleportingEntity:(Entity *)entity
{
	TeleportInfo *teleportInfo = [[[TeleportInfo alloc] initWithEntity:entity] autorelease];
	[_teleportInfos addObject:teleportInfo];
}

@end
