//
//  WobbleComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WobbleComponent.h"
#import "StringCollection.h"

@implementation WobbleComponent

@synthesize hasWobbled = _hasWobbled;

-(id) init
{
	if (self = [super init])
	{
		_firstWobbleAnimationNames = [StringCollection new];
		_wobbleAnimationNames = [StringCollection new];
		_wobbleFollowupAnimationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		[_firstWobbleAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"firstWobbleAnimation"];
		[_wobbleAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"wobbleAnimation"];
		[_wobbleFollowupAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"wobbleFollowupAnimation"];
	}
	return self;
}

-(void) dealloc
{
	[_firstWobbleAnimationNames release];
	[_wobbleAnimationNames release];
	[_wobbleFollowupAnimationNames release];
	
	[super dealloc];
}

-(NSString *) randomFirstWobbleAnimationName
{
	if ([_firstWobbleAnimationNames hasStrings])
	{
		return [_firstWobbleAnimationNames randomString];
	}
	else
	{
		return [self randomWobbleAnimationName];
	}
}

-(NSString *) randomWobbleAnimationName
{
	return [_wobbleAnimationNames randomString];
}

-(NSString *) randomWobbleFollowupAnimationName
{
	return [_wobbleFollowupAnimationNames randomString];
}

@end
