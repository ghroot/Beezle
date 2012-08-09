//
//  TutorialEntityTypeTriggerDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialTriggerDescription.h"

@interface TutorialEntityTypeTriggerDescription : TutorialTriggerDescription
{
	NSString *_entityType;
}

@property (nonatomic, readonly) NSString *entityType;

-(id) initWithEntityType:(NSString *)entityType;

@end
