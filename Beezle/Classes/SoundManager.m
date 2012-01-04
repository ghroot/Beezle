//
//  SoundManager.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

@implementation SoundManager

+(SoundManager *) sharedManager
{
    static SoundManager *manager = 0;
    if (!manager)
    {
        manager = [[self alloc] init];
    }
    return manager;
}

-(void) preloadSounds
{
//	[[SimpleAudioEngine sharedEngine] preloadEffect:@"11097__a43__a43-blipp.aif"];
//	[[SimpleAudioEngine sharedEngine] preloadEffect:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
//	[[SimpleAudioEngine sharedEngine] preloadEffect:@"27134__zippi1__fart1.wav"];
//	[[SimpleAudioEngine sharedEngine] preloadEffect:@"52144__blaukreuz__imp-02.m4a"];
//	[[SimpleAudioEngine sharedEngine] preloadEffect:@"33369__herbertboland__mouthpop.wav"];
}

-(void) playSound:(NSString *)name
{
//	[[SoundManager sharedManager] playSound:name];
}

@end
