//
//  ParticleGroupSelectMenuItem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticleGroupSelectMenuItem.h"

@implementation ParticleGroupSelectMenuItem

@synthesize particleNames = _particleNames;

-(id) initWithParticleNames:(NSArray *)particleNames target:(id)target selector:(SEL)selector
{
	if (self = [super initWithString:@"Particles" target:target selector:selector])
	{
		_particleNames = [particleNames retain];
	}
	return self;
}

-(void) dealloc
{
	[_particleNames release];

	[super dealloc];
}

@end
