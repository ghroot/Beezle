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
	NSDictionary *_musicFilePathsByName;
	NSDictionary *_sfxInfoDictsByName;
	NSMutableDictionary *_soundIdsBySoundName;
	NSString *_currentMusicName;
	NSString *_lastRequestedMusicNameWhileNonFunctinal;
	BOOL _isMuted;
}

@property (nonatomic, readonly) BOOL isMuted;

+(SoundManager *) sharedManager;

-(void) setup;
-(void) playSound:(NSString *)name;
-(void) stopSound:(NSString *)name;
-(void) playMusic:(NSString *)name loop:(BOOL)loop;
-(void) playMusic:(NSString *)name;
-(void) stopMusic;
-(void) mute;
-(void) unMute;
-(NSString *) soundFilePathForSfx:(NSString *)name;

@end
