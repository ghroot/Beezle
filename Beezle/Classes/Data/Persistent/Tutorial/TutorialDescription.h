//
//  TutorialDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class TutorialTriggerDescription;

@interface TutorialDescription : NSObject
{
	NSString *_id;
	TutorialTriggerDescription *_triggerDescription;
}

@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) TutorialTriggerDescription *triggerDescription;

-(id) initWithId:(NSString *)id andTrigger:(TutorialTriggerDescription *)triggerDescription;

@end
