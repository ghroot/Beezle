//
//  SessionTracker.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface SessionTracker : NSObject

+(SessionTracker *) sharedTracker;

-(void) start;
-(void) trackStartedLevel:(NSString *)levelName;
-(void) trackCompletedLevel:(NSString *)levelName;
-(void) trackFailedLevel:(NSString *)levelName;
-(void) trackInteraction:(NSString *)type name:(NSString *)interactionName;
-(void) trackScreen:(NSString *)screenName;

@end
