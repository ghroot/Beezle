//
//  PlayerInformation.h
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface PlayerInformation : NSObject
{
	NSMutableArray *_consumedDisposableIds;
	NSMutableArray *_consumedDisposableIdsThisLevel;
}

+(PlayerInformation *) sharedInformation;

-(void) resetConsumedDisposableIdsThisLevel;
-(void) storeConsumedDisposableIdsFromThisLevel;
-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId;
-(BOOL) hasConsumedDisposableId:(NSString *)disposableId;

@end
