//
//  PlayerInformation.h
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelSession;

@interface PlayerInformation : NSObject
{
	NSMutableDictionary *_pollenCollectionRecordByLevelName;
}

+(PlayerInformation *) sharedInformation;

-(void) save;
-(void) reset;
-(BOOL) isRecord:(LevelSession *)levelSession;
-(void) store:(LevelSession *)levelSession;
-(int) totalNumberOfCollectedPollen;

@end
