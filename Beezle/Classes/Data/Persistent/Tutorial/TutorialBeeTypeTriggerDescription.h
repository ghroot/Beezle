//
//  TutorialBeeTypeTriggerDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialTriggerDescription.h"

@class BeeType;

@interface TutorialBeeTypeTriggerDescription : TutorialTriggerDescription
{
	BeeType *_beeType;
}

@property (nonatomic, readonly) BeeType *beeType;

-(id) initWithBeeType:(BeeType *)beeType;

@end
