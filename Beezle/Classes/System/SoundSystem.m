//
// Created by Marcus on 05/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SoundSystem.h"
#import "SoundComponent.h"
#import "SimpleAudioEngine.h"
#import "SoundManager.h"

@implementation SoundSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[SoundComponent class]];
	return self;
}

-(void) entityAdded:(Entity *)entity
{
	SoundComponent *soundComponent = [SoundComponent getFrom:entity];
	if ([soundComponent loopingSoundName] != nil)
	{
		NSString *soundFilePath = [[SoundManager sharedManager] soundFilePathForSfx:[soundComponent loopingSoundName]];
		CDSoundSource *soundSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:soundFilePath];
		[soundSource setLooping:TRUE];
		[soundSource play];
		[soundComponent setSoundSource:soundSource];
	}
}

@end
