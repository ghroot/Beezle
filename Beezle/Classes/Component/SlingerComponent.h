//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeTypes.h"

@interface SlingerComponent : Component
{
	NSMutableArray *_queuedBeeTypes;
}

@property (nonatomic, readonly) NSArray *queuedBeeTypes;

-(void) pushBeeType:(BeeType)beeType;
-(BeeType) popNextBeeType;
-(BOOL) hasMoreBees;

@end
