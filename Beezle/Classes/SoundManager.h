//
//  SoundManager.h
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface SoundManager : NSObject

+(SoundManager *) sharedManager;

-(void) preloadSounds;
-(void) playSound:(NSString *)name;

@end
