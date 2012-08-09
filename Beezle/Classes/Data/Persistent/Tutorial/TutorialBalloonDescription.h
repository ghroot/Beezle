//
//  TutorialBalloonDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialDescription.h"

@interface TutorialBalloonDescription : TutorialDescription
{
	NSString *_frameName;
}

@property (nonatomic, readonly) NSString *frameName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFrameName:(NSString *)frameName;

@end
