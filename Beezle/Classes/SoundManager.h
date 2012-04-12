//
//  SoundManager.h
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "cocos2d.h"

@interface SoundManager : NSObject
{
    BOOL _setupHasRun;
    BOOL _isFunctional;
	NSDictionary *_soundFilePathsByName;
	NSMutableDictionary *_soundIdsBySoundName;
}

+(SoundManager *) sharedManager;

-(void) setup;
-(void) playSound:(NSString *)name;
-(void) stopSound:(NSString *)name;
-(void) playMusic:(NSString *)name loop:(BOOL)loop;
-(void) playMusic:(NSString *)name;
-(void) stopMusic;

@end
