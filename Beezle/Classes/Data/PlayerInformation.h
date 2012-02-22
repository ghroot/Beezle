//
//  PlayerInformation.h
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface PlayerInformation : NSObject
{
	NSMutableDictionary *_pollenCollectionRecordByLevelName;
	int _numberOfCollectedPollenThisLevel;
}

+(PlayerInformation *) sharedInformation;

-(void) save;
-(void) reset;
-(void) resetForThisLevel;
-(void) storeForThisLevel:(NSString *)levelName;
-(void) consumedEntity:(Entity *)entity;
-(BOOL) isCurrentLevelRecord:(NSString *)levelName;
-(int) numberOfCollectedPollen;

@end
