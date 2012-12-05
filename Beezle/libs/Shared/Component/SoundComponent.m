//
//  SoundComponent.m
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundComponent.h"
#import "StringCollection.h"
#import "CocosDenshion.h"
#import "CCDirector.h"
#import "CCActionManager.h"

@implementation SoundComponent

@synthesize loopingSoundName = _loopingSoundName;
@synthesize soundSource = _soundSource;

-(id) init
{
    if (self = [super init])
    {
        _defaultCollisionSoundNames = [StringCollection new];
        _defaultDestroySoundNames = [StringCollection new];
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
		if ([typeComponentDict objectForKey:@"loopingSound"] != nil)
		{
			_loopingSoundName = [[typeComponentDict objectForKey:@"loopingSound"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_defaultCollisionSoundNames release];
    [_defaultDestroySoundNames release];
	[_loopingSoundName release];
	if (_soundSource != nil)
	{
		[[[CCDirector sharedDirector] actionManager] removeAllActionsFromTarget:_soundSource];
		[_soundSource stop];
	}
	[_soundSource release];
    
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
