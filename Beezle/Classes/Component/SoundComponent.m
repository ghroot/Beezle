//
//  SoundComponent.m
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundComponent.h"

@implementation SoundComponent

@synthesize defaultCollisionSoundName = _defaultCollisionSoundName;
@synthesize defaultDestroySoundName = _defaultDestroySoundName;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"defaultCollisionSound"] != nil)
		{
			_defaultCollisionSoundName = [[dict objectForKey:@"defaultCollisionSound"] retain];
		}
		if ([dict objectForKey:@"defaultDestroySound"] != nil)
		{
			_defaultDestroySoundName = [[dict objectForKey:@"defaultDestroySound"] retain];
		}
	}
	return self;
}

-(id) init
{
    if (self = [super init])
    {
		_name = @"sound";
    }
    return self;
}

-(void) dealloc
{
	[_defaultCollisionSoundName release];
    [_defaultDestroySoundName release];
    
    [super dealloc];
}

@end
