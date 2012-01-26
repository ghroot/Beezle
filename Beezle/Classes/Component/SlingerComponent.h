//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@interface SlingerComponent : Component
{
	NSMutableArray *_queuedBeeTypes;
	BeeType *_loadedBeeType;
}

@property (nonatomic, readonly) NSArray *queuedBeeTypes;
@property (nonatomic, readonly) BeeType *loadedBeeType;

-(void) pushBeeType:(BeeType *)beeType;
-(BeeType *) popNextBeeType;
-(BOOL) hasMoreBees;
-(void) clearBeeTypes;
-(void) loadNextBee;
-(void) clearLoadedBee;
-(BOOL) hasLoadedBee;

@end
