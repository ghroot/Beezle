//
//  AnimationSoundMediator
//  Beezle
//
//  Created by marcus on 30/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimationSoundMediator.h"
#import "ccMacros.h"
#import "SoundManager.h"

@interface AnimationSoundMediator ()

-(void) handleNotification:(NSNotification *)notification;

@end

@implementation AnimationSoundMediator

+(AnimationSoundMediator *) sharedMediator
{
	static AnimationSoundMediator *cache = 0;
	if (!cache)
	{
		cache = [[self alloc] init];
	}
	return cache;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}


-(void) initialise
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:CCAnimationFrameDisplayedNotification object:nil];
}

-(void) handleNotification:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	if ([[userInfo objectForKey:@"type"] isEqualToString:@"playSound"])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CCSprite *sprite = [notification object];
		CGAffineTransform worldPosition = [sprite nodeToWorldTransform];
		if (worldPosition.tx >= 0.0f && worldPosition.tx <= winSize.width &&
				worldPosition.ty >= 0.0f && worldPosition.ty <= winSize.width)
		{
			NSString *soundName = [userInfo objectForKey:@"soundName"];
			[[SoundManager sharedManager] playSound:soundName];
		}
	}
}

@end
