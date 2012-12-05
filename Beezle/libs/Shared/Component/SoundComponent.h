//
//  SoundComponent.h
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringCollection;
@class CDSoundSource;

/**
  Sounds for collision and destruction.
 */
@interface SoundComponent : Component
{
    // Type
	StringCollection *_defaultCollisionSoundNames;
    StringCollection *_defaultDestroySoundNames;
	NSString *_loopingSoundName;

	// Transient
	CDSoundSource *_soundSource;
}

@property (nonatomic, readonly) NSString *loopingSoundName;
@property (nonatomic, retain) CDSoundSource *soundSource;

-(BOOL) hasDefaultCollisionSoundName;
-(void) setDefaultCollisionSoundName:(NSString *)defaultCollisionSoundName;
-(NSString *) randomDefaultCollisionSoundName;
-(void) setDefaultDestroySoundName:(NSString *)defaultDestroySoundName;
-(BOOL) hasDefaultDestroySoundName;
-(NSString *) randomDefaultDestroySoundName;

@end
