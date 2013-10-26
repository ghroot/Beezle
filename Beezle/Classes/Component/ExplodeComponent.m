//
//  ExplodeComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplodeComponent.h"
#import "StringCollection.h"

@implementation ExplodeComponent

@synthesize explodeOnTap = _explodeOnTap;
@synthesize radius = _radius;
@synthesize explodeStartAnimationName = _explodeStartAnimationName;
@synthesize damage = _damage;
@synthesize alsoExplodesCrumble = _alsoExplodesCrumble;
@synthesize alsoExplodesPollen = _alsoExplodesPollen;
@synthesize explosionState = _explosionState;

-(id) init
{
	if (self = [super init])
	{
		_explodeSoundNames = [StringCollection new];
        _explosionState = NOT_EXPLODED;
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		_explodeOnTap = [[typeComponentDict objectForKey:@"explodeOnTap"] boolValue];
        _radius = [[typeComponentDict objectForKey:@"radius"] intValue];
        _explodeStartAnimationName = [[typeComponentDict objectForKey:@"explodeStartAnimation"] copy];
		[_explodeSoundNames addStringsFromDictionary:typeComponentDict baseName:@"explodeSound"];
		if ([typeComponentDict objectForKey:@"damage"] != nil)
		{
			_damage = [[typeComponentDict objectForKey:@"damage"] intValue];
		}
		else
		{
			_damage = 1;
		}
		_alsoExplodesCrumble = [[typeComponentDict objectForKey:@"alsoExplodesCrumble"] boolValue];
		_alsoExplodesPollen = [[typeComponentDict objectForKey:@"alsoExplodesPollen"] boolValue];
	}
	return self;
}

-(void) dealloc
{
	[_explodeStartAnimationName release];
	[_explodeSoundNames release];
	
	[super dealloc];
}

-(NSString *) randomExplodeSoundName
{
	return [_explodeSoundNames randomString];
}

@end
