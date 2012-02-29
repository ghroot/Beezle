//
//  SoundManager.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

@interface SoundManager()

-(void) asynchronousSetup;
-(void) loadSoundMappings;
-(void) preloadSounds;

@end

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

-(id) init
{
	if (self = [super init])
	{
		_soundIdsBySoundName = [NSMutableDictionary new];
	}
	return self;
}

-(void) dealloc
{
	[_soundFilePathsByName release];
	[_soundIdsBySoundName release];
	
	[super dealloc];
}

-(void) setup
{
    if (_setupHasRun)
    {
        return;
    }
    else
    {
        _setupHasRun = TRUE;
    }
    
    NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(asynchronousSetup) object:nil];
    [queue addOperation:operation];
    [operation autorelease];
}

-(void) asynchronousSetup
{
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
		[NSThread sleepForTimeInterval:0.1];
	}
    
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine != nil ||
        audioManager.soundEngine.functioning)
    {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:TRUE];
        [SimpleAudioEngine sharedEngine];
		[self loadSoundMappings];
        [self preloadSounds];
        
        _isFunctional = TRUE;
    }
}

-(void) loadSoundMappings
{
	NSString *fileName = @"Sounds.plist";
	NSString *filePath = [CCFileUtils fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	_soundFilePathsByName = [[NSDictionary dictionaryWithDictionary:[dict objectForKey:@"sounds"]] retain];
}

-(void) preloadSounds
{
	for (NSString *soundFilePath in [_soundFilePathsByName allValues])
	{
		[[SimpleAudioEngine sharedEngine] preloadEffect:soundFilePath];
	}
	
	// TEMP: Remove/move to Sounds.plist
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"11097__a43__a43-blipp.aif"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"27134__zippi1__fart1.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"52144__blaukreuz__imp-02.m4a"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"33369__herbertboland__mouthpop.wav"];
}

-(void) playSound:(NSString *)name
{
    if (_isFunctional &&
		name != nil)
    {
		NSString *soundFilePath = [_soundFilePathsByName objectForKey:name];
		ALuint soundId = 0;
		if (soundFilePath != nil)
		{
			soundId = [[SimpleAudioEngine sharedEngine] playEffect:soundFilePath];
		}
		else
		{
			// TEMP
			soundId = [[SimpleAudioEngine sharedEngine] playEffect:name];
		}
		[_soundIdsBySoundName setObject:[NSNumber numberWithInt:soundId] forKey:name];
    }
}

-(void) stopSound:(NSString *)name
{
	if (_isFunctional &&
		name != nil)
	{
		int soundId = [[_soundIdsBySoundName objectForKey:name] intValue];
		[[SimpleAudioEngine sharedEngine] stopEffect:soundId];
	}
}

-(void) playMusic:(NSString *)name
{
	if (_isFunctional &&
		name != nil)
    {
		NSString *musicFilePath = [_soundFilePathsByName objectForKey:name];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:musicFilePath loop:TRUE];
    }
}

-(void) stopMusic
{
	if (_isFunctional)
	{
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
}

@end
