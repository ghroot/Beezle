//
//  LevelSender.h
//  Beezle
//
//  Created by Me on 03/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface LevelSender : NSObject

+(LevelSender *) sharedSender;

-(void) sendEditedLevels;

@end
