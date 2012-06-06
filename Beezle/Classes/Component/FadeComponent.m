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

@synthesize currentAnimationName = _currentAnimationName;

-(id) init
{
	if (self = [super init])
	{
		_animationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_duration = [[typeComponentDict objectForKey:@"duration"] floatValue];
		[_animationNames addStringsFromDictionary:typeComponentDict baseName:@"animation"];
	}
	return self;
}

-(void) dealloc
{
	[_animationNames release];
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

-(NSString *) targetAnimationName
{
	float timePerAnimationName = _duration / [[_animationNames strings] count];
	int animationNameIndex = floorf((_duration - _countdown) / timePerAnimationName);
	return [[_animationNames strings] objectAtIndex:animationNameIndex];
}

@end