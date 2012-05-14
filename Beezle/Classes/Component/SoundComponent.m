//
//  SoundComponent.m
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundComponent.h"
#import "StringList.h"

@implementation SoundComponent

-(id) init
{
    if (self = [super init])
    {
		_name = @"sound";
        _defaultCollisionSoundNames = [StringList new];
        _defaultDestroySoundNames = [StringList new];
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        [_defaultCollisionSoundNames addStringsFromDictionary:typeComponentDict baseName:@"defaultCollisionSound"];
        [_defaultDestroySoundNames addStringsFromDictionary:typeComponentDict baseName:@"defaultDestroySound"];
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
	return [_defaultCollisionSoundNames hasStrings];
}

-(void) setDefaultCollisionSoundName:(NSString *)defaultCollisionSoundName
{
    [_defaultCollisionSoundNames addString:defaultCollisionSoundName];
}

-(NSString *) randomDefaultCollisionSoundName
{
    return [_defaultCollisionSoundNames randomString];
}

-(BOOL) hasDefaultDestroySoundName
{
    return [_defaultDestroySoundNames hasStrings];
}

-(void) setDefaultDestroySoundName:(NSString *)defaultDestroySoundName
{
    [_defaultDestroySoundNames addString:defaultDestroySoundName];
}

-(NSString *) randomDefaultDestroySoundName
{
    return [_defaultDestroySoundNames randomString];
}

@end
