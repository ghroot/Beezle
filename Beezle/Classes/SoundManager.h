//
//  SoundManager.h
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleAudioEngine.h"

@interface SoundManager : NSObject
{
    BOOL _setupHasRun;
    BOOL _isFunctional;
}

+(SoundManager *) sharedManager;

-(void) setup;
-(void) playSound:(NSString *)name;

@end
