//
// Created by Marcus on 2013-10-03.
//

#import "StingerComponent.h"

@implementation StingerComponent

@synthesize inflateStartAnimation = _inflateStartAnimation;
@synthesize inflateEndAnimation = _inflateEndAnimation;
@synthesize stingSound = _stingSound;
@synthesize countdownUntilNextPossibleSting = _countdownUntilNextPossibleSting;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_inflateStartAnimation = [[typeComponentDict objectForKey:@"inflateStartAnimation"] copy];
		_inflateEndAnimation = [[typeComponentDict objectForKey:@"inflateEndAnimation"] copy];
		_stingSound = [[typeComponentDict objectForKey:@"stingSound"] copy];
	}
	return self;
}

-(void) dealloc
{
	[_inflateStartAnimation release];
	[_inflateEndAnimation release];
	[_stingSound release];

	[super dealloc];
}

@end