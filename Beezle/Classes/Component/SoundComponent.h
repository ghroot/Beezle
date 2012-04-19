//
//  SoundComponent.h
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringList;

@interface SoundComponent : Component
{
	StringList *_defaultCollisionSoundNames;
    StringList *_defaultDestroySoundNames;
}

-(BOOL) hasDefaultCollisionSoundName;
-(void) setDefaultCollisionSoundName:(NSString *)defaultCollisionSoundName;
-(NSString *) randomDefaultCollisionSoundName;
-(void) setDefaultDestroySoundName:(NSString *)defaultDestroySoundName;
-(BOOL) hasDefaultDestroySoundName;
-(NSString *) randomDefaultDestroySoundName;

@end
