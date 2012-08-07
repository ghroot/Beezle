//
//  ParticleSelectMenuItem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticleSelectMenuItem.h"

@implementation ParticleSelectMenuItem

-(id) initWithParticleName:(NSString *)particleName target:(id)target selector:(SEL)selector
{
	if (self = [super initWithString:particleName target:target selector:selector])
	{
		_particleName = [particleName copy];
	}
	return self;
}

-(void) dealloc
{
	[_particleName release];

	[super dealloc];
}

@end
