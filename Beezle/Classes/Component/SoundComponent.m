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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
        [_defaultCollisionSoundNames addStringsFromDictionary:dict baseName:@"defaultCollisionSound"];
        [_defaultDestroySoundNames addStringsFromDictionary:dict baseName:@"defaultDestroySound"];
	}
	return self;
}

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
