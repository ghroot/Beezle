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
	NSString *_buttonFileName;
}

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *buttonFileName;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription fileName:(NSString *)fileName buttonFileName:(NSString *)buttonFileName;

@end
