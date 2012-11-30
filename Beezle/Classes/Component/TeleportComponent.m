//
//  TeleportComponent.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportComponent.h"
#import "TeleportInfo.h"
#import "Utils.h"

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

		// Support iPhone 5 resolution width by offsetting layout positions
		_outPosition.x += [Utils universalScreenStartX];

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

	// Support iPhone 5 resolution width by offsetting layout positions
	CGPoint outPosition = CGPointMake(_outPosition.x - [Utils universalScreenStartX], _outPosition.y);

	[instanceComponentDict setObject:NSStringFromCGPoint(outPosition) forKey:@"outPosition"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:_outRotation] forKey:@"outRotation"];

	return instanceComponentDict;
}

-(void) addTeleportingEntity:(Entity *)entity
{
	TeleportInfo *teleportInfo = [[[TeleportInfo alloc] initWithEntity:entity] autorelease];
	[_teleportInfos addObject:teleportInfo];
}

@end
