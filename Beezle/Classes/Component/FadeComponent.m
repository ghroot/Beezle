//
//  FadeComponent
//  Beezle
//
//  Created by marcus on 06/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FadeComponent.h"
#import "StringCollection.h"

@implementation FadeComponent

@synthesize introAnimationName = _introAnimationName;
@synthesize currentAnimationName = _currentAnimationName;

-(id) init
{
	if (self = [super init])
	{
		_fadeAnimationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_duration = [[typeComponentDict objectForKey:@"duration"] floatValue];
		_introAnimationName = [[typeComponentDict objectForKey:@"introAnimation"] copy];
		[_fadeAnimationNames addStringsFromDictionary:typeComponentDict baseName:@"fadeAnimation"];
	}
	return self;
}

-(id) initWithDuration:(float)duration introAnimationName:(NSString *)introAnimationName fadeAnimationNames:(NSArray *)fadeAnimationNames
{
	if (self = [self init])
	{
		_duration = duration;
		_introAnimationName = [introAnimationName copy];
		for (NSString *fadeAnimationName in fadeAnimationNames)
		{
			[_fadeAnimationNames addString:fadeAnimationName];
		}
	}
	return self;
}

-(void) dealloc
{
	[_fadeAnimationNames release];
	[_introAnimationName release];
	[_currentAnimationName release];

	[super dealloc];
}

-(void) resetCountdown
{
	_countdown = _duration;
}

-(void) decreaseCountdown:(float)delta
{
	_countdown -= delta;
}

-(BOOL) hasCountdownReachedZero
{
	return _countdown <= 0;
}

-(int) targetAnimationIndex
{
	float timePerAnimationName = _duration / [[_fadeAnimationNames strings] count];
	int animationIndex = floorf((_duration - _countdown) / timePerAnimationName);
	return animationIndex;
}

-(NSString *) targetAnimationName
{
	return [[_fadeAnimationNames strings] objectAtIndex:[self targetAnimationIndex]];
}

@end