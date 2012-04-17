//
//  SoundComponent.m
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundComponent.h"

@implementation SoundComponent

@synthesize defaultCollisionSoundNames = _defaultCollisionSoundNames;
@synthesize defaultDestroySoundNames = _defaultDestroySoundNames;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"defaultCollisionSound"] != nil)
		{
			[_defaultCollisionSoundNames addObject:[dict objectForKey:@"defaultCollisionSound"]];
		}
		else if ([dict objectForKey:@"defaultCollisionSounds"])
		{
			[_defaultCollisionSoundNames addObjectsFromArray:[dict objectForKey:@"defaultCollisionSounds"]];
		}
		if ([dict objectForKey:@"defaultDestroySound"] != nil)
		{
			[_defaultDestroySoundNames addObject:[dict objectForKey:@"defaultDestroySound"]];
		}
		else if ([dict objectForKey:@"defaultDestroySounds"])
		{
			[_defaultDestroySoundNames addObjectsFromArray:[dict objectForKey:@"defaultDestroySounds"]];
		}
	}
	return self;
}

-(id) init
{
    if (self = [super init])
    {
		_name = @"sound";
		_defaultCollisionSoundNames = [NSMutableArray new];
		_defaultDestroySoundNames = [NSMutableArray new];
    }
    return self;
}

-(void) dealloc
{
	[_defaultCollisionSoundNames release];
    [_defaultDestroySoundNames release];
    
    [super dealloc];
}

-(BOOL) hasDefaultCollisionSoundName
{
	return [_defaultCollisionSoundNames count] > 0;
}

-(void) setDefaultCollisionSoundName:(NSString *)defaultCollisionSoundName
{
	[_defaultCollisionSoundNames addObject:defaultCollisionSoundName];
}

-(NSString *) randomDefaultCollisionSoundName
{
	int index = rand() % [_defaultCollisionSoundNames count];
	return [_defaultCollisionSoundNames objectAtIndex:index];
}

-(BOOL) hasDefaultDestroySoundName
{
	return [_defaultDestroySoundNames count] > 0;
}

-(void) setDefaultDestroySoundName:(NSString *)defaultDestroySoundName
{
	[_defaultDestroySoundNames addObject:defaultDestroySoundName];
}

-(NSString *) randomDefaultDestroySoundName
{
	int index = rand() % [_defaultDestroySoundNames count];
	return [_defaultDestroySoundNames objectAtIndex:index];
}

@end
