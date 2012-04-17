//
//  SoundComponent.h
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface SoundComponent : Component
{
	NSMutableArray *_defaultCollisionSoundNames;
    NSMutableArray *_defaultDestroySoundNames;
}

@property (nonatomic, retain) NSArray *defaultCollisionSoundNames;
@property (nonatomic, retain) NSArray *defaultDestroySoundNames;

-(BOOL) hasDefaultCollisionSoundName;
-(void) setDefaultCollisionSoundName:(NSString *)defaultCollisionSoundName;
-(NSString *) randomDefaultCollisionSoundName;
-(void) setDefaultDestroySoundName:(NSString *)defaultDestroySoundName;
-(BOOL) hasDefaultDestroySoundName;
-(NSString *) randomDefaultDestroySoundName;

@end
