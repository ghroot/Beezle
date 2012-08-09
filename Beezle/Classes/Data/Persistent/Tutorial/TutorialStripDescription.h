//
//  TutorialStripDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialDescription.h"

@interface TutorialStripDescription : TutorialDescription
{
	NSString *_fileName;
}

@property (nonatomic, readonly) NSString *fileName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFileName:(NSString *)fileName;

@end
