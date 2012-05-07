//
//  BeeaterComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeaterComponent.h"
#import "NotificationTypes.h"
#import "StringList.h"

@implementation BeeaterComponent

@synthesize containedBeeType = _containedBeeType;
@synthesize showBeeAnimationNameFormat = _showBeeAnimationNameFormat;
@synthesize showBeeBetweenAnimationNames = _showBeeBetweenAnimationNames;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"defaultContainedBeeType"] != nil)
		{
			NSString *defaultContainedBeeTypeAsString = [dict objectForKey:@"defaultContainedBeeType"];
			BeeType *defaultContainedBeeType = [BeeType enumFromName:defaultContainedBeeTypeAsString];
			_containedBeeType = defaultContainedBeeType;
		}
        if ([dict objectForKey:@"showBeeAnimationFormat"] != nil)
        {
            _showBeeAnimationNameFormat = [[dict objectForKey:@"showBeeAnimationFormat"] copy];
        }
		[_showBeeBetweenAnimationNames addStringsFromDictionary:dict baseName:@"showBeeBetweenAnimation"];
	}
	return self;
}

-(id) init
{
	if (self = [super init])
	{
		_name = @"beeater";
		_containedBeeType = nil;
		_showBeeBetweenAnimationNames = [StringList new];
	}
	return self;
}

-(void) dealloc
{
    [_showBeeAnimationNameFormat release];
    [_showBeeBetweenAnimationNames release];
    
    [super dealloc];
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
