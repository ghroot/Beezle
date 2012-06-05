//
//  BeeaterComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeaterComponent.h"
#import "StringCollection.h"

static const int MIN_SYNCHRONISED_ANIMATION_INTERVAL = 2000;
static const int MAX_SYNCHRONISED_ANIMATION_INTERVAL = 4000;

@implementation BeeaterComponent

-(id) init
{
	if (self = [super init])
	{
		_showBeeBetweenAnimationNames = [StringCollection new];
		_synchronisedBodyAnimationNames = [StringCollection new];
		_synchronisedHeadAnimationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _showBeeAnimationNameFormat = [[typeComponentDict objectForKey:@"showBeeAnimationFormat"] copy];
		[_showBeeBetweenAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"showBeeBetweenAnimation"];
		[_synchronisedBodyAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"synchronisedBodyAnimation"];
		[_synchronisedHeadAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"synchronisedHeadAnimation"];
	}
	return self;
}

-(void) dealloc
{
    [_showBeeAnimationNameFormat release];
    [_showBeeBetweenAnimationNames release];
	[_synchronisedBodyAnimationNames release];
	[_synchronisedHeadAnimationNames release];
    
    [super dealloc];
}

-(NSString *) headAnimationNameForBeeType:(BeeType *)beeType string:(NSString *)string
{
	return [NSString stringWithFormat:_showBeeAnimationNameFormat, string, [beeType capitalizedString]];
}

-(NSString *) randomBetweenHeadAnimationName
{
	return [_showBeeBetweenAnimationNames randomString];
}

-(void) resetSynchronisedAnimationCountdown
{
	_synchronisedAnimationCountdown = MIN_SYNCHRONISED_ANIMATION_INTERVAL + (int)(rand() % (MAX_SYNCHRONISED_ANIMATION_INTERVAL - MIN_SYNCHRONISED_ANIMATION_INTERVAL));
}

-(void) decreaseSynchronisedAnimationCountdown
{
	_synchronisedAnimationCountdown--;
}

-(BOOL) hasSynchronisedAnimationCountdownReachedZero
{
	return _synchronisedAnimationCountdown <= 0;
}

-(NSString *) randomSynchronisedBodyAnimationName
{
	return [_synchronisedBodyAnimationNames randomString];
}

-(NSString *) randomSynchronisedHeadAnimationName
{
	return [_synchronisedHeadAnimationNames randomString];
}

@end
