//
//  BeeaterComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeaterComponent.h"
#import "NotificationTypes.h"

@implementation BeeaterComponent

@synthesize containedBeeType = _containedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_name = @"beeater";
		_containedBeeType = nil;
	}
	return self;
}

-(void) setContainedBeeType:(BeeType *)containedBeeType
{
	_containedBeeType = containedBeeType;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED object:self];
}

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[_containedBeeType name] forKey:@"containedBeeType"];
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"containedBeeType"])
	{
		NSString *containedBeeTypeAsString = [dict objectForKey:@"containedBeeType"];
		BeeType *containedBeeType = [BeeType enumFromName:containedBeeTypeAsString];
		[self setContainedBeeType:containedBeeType];
	}
}

-(BOOL) hasContainedBee
{
	return _containedBeeType != nil;
}

@end
