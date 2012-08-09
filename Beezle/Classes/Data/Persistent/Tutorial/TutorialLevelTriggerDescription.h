//
//  TutorialLevelTriggerDescription.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialTriggerDescription.h"

@interface TutorialLevelTriggerDescription : TutorialTriggerDescription
{
	NSString *_levelName;
}

@property (nonatomic, readonly) NSString *levelName;

-(id) initWithLevelName:(NSString *)levelName;

@end
