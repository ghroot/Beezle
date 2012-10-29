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
	NSString *_fileName;
	CGPoint _offset;
}

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) CGPoint offset;

-(id) initWithId:(NSString *)id trigger:(TutorialTriggerDescription *)triggerDescription andFileName:(NSString *)fileName andOffset:(CGPoint)offset;

@end
