//
//  TutorialOrganizer.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class TutorialBalloonDescription;
@class TutorialStripDescription;

@interface TutorialOrganizer : NSObject
{
	NSMutableArray *_tutorialDescriptions;
}

@property (nonatomic, readonly) NSArray *tutorialDescriptions;

+(TutorialOrganizer *) sharedOrganizer;

-(void) addTutorialsWithDictionary:(NSDictionary *)dict;
-(void) addTutorialsWithFile:(NSString *)fileName;

-(TutorialBalloonDescription *) tutorialBalloonDescriptionForLevel:(NSString *)levelName;
-(TutorialStripDescription *) tutorialStripDescriptionForLevel:(NSString *)levelName;

@end
