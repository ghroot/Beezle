//
//  SoundManager.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

static const float MUSIC_VOLUME = 1.0f;
static const float SFX_VOLUME = 0.6f;

@interface SoundManager()

-(void) asynchronousSetup;
-(void) loadSoundMappings;
-(void) preloadSoundEffects;

@end

@implementation SoundManager

@synthesize isMuted = _isMuted;

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
	[_musicFilePathsByName release];
	[_sfxInfoDictsByName release];
	[_soundIdsBySoundName release];
	[_currentMusicName release];
	[_lastRequestedMusicNameWhileNonFunctinal release];
	
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
		[self preloadSoundEffects];

        _isFunctional = TRUE;

		if (_lastRequestedMusicNameWhileNonFunctinal != nil)
		{
			[self playMusic:_lastRequestedMusicNameWhileNonFunctinal];
			[_lastRequestedMusicNameWhileNonFunctinal release];
			_lastRequestedMusicNameWhileNonFunctinal = nil;
		}
    }
}

-(void) loadSoundMappings
{
	NSString *fileName = @"Sounds.plist";
	NSString *filePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	_musicFilePathsByName = [[NSDictionary dictionaryWithDictionary:[dict objectForKey:@"music"]] retain];
	_sfxInfoDictsByName = [[NSDictionary dictionaryWithDictionary:[dict objectForKey:@"sfx"]] retain];
}

-(void) preloadSoundEffects
{
	for (NSDictionary *soundInfoDict in [_sfxInfoDictsByName allValues])
	{
		[[SimpleAudioEngine sharedEngine] preloadEffect:[soundInfoDict objectForKey:@"fileName"]];
	}
}

-(void) playSound:(NSString *)name
{
	if (_isFunctional &&
			name != nil)
	{
		NSDictionary *soundInfoDict = [_sfxInfoDictsByName objectForKey:name];
		NSString *soundFilePath = [soundInfoDict objectForKey:@"fileName"];
		float volume = [[soundInfoDict objectForKey:@"volume"] floatValue];
		ALuint soundId = [[SimpleAudioEngine sharedEngine] playEffect:soundFilePath pitch:1.0f pan:0.0f gain:volume];
		[_soundIdsBySoundName setObject:[NSNumber numberWithInt:soundId] forKey:name];
	}
}

-(void) stopSound:(NSString *)name
{
	if (_isFunctional &&
		name != nil)
	{
		if ([_soundIdsBySoundName objectForKey:name] != nil)
		{
			int soundId = [[_soundIdsBySoundName objectForKey:name] intValue];
			[[SimpleAudioEngine sharedEngine] stopEffect:soundId];
		}
	}
}

-(void) playMusic:(NSString *)name loop:(BOOL)loop
{
	if (name != nil)
	{
		if (_isFunctional)
		{
			if (_currentMusicName == nil ||
					![name isEqualToString:_currentMusicName])
			{
				[_currentMusicName release];
				_currentMusicName = [name copy];
				NSString *musicFilePath = [_musicFilePathsByName objectForKey:name];
				[[SimpleAudioEngine sharedEngine] playBackgroundMusic:musicFilePath loop:loop];
			}
		}
		else
		{
			if (_lastRequestedMusicNameWhileNonFunctinal != nil)
			{
				[_lastRequestedMusicNameWhileNonFunctinal release];
			}
			_lastRequestedMusicNameWhileNonFunctinal = [name copy];
		}
	}
}

-(void) playMusic:(NSString *)name
{
	[self playMusic:name loop:TRUE];
}

-(void) stopMusic
{
	if (_isFunctional)
	{
		[_currentMusicName release];
		_currentMusicName = nil;
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	else
	{
		if (_lastRequestedMusicNameWhileNonFunctinal != nil)
		{
			[_lastRequestedMusicNameWhileNonFunctinal release];
			_lastRequestedMusicNameWhileNonFunctinal = nil;
		}
	}
}

-(void) mute
{
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
	_isMuted = TRUE;
}

-(void) unMute
{
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:MUSIC_VOLUME];
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:SFX_VOLUME];
	_isMuted = FALSE;
}

-(NSString *) soundFilePathForSfx:(NSString *)name
{
	NSDictionary *soundInfoDict = [_sfxInfoDictsByName objectForKey:name];
	return [soundInfoDict objectForKey:@"fileName"];
}

@end
