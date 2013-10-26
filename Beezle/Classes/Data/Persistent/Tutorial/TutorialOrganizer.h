//
//  TutorialOrganizer.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class TutorialBalloonDescription;
@class TutorialStripDescription;
@class BeeType;
@class TutorialDescription;

@interface TutorialOrganizer : NSObject
{
	NSMutableArray *_tutorialDescriptions;
}

@property (nonatomic, readonly) NSArray *tutorialDescriptions;

+(TutorialOrganizer *) sharedOrganizer;

-(void) addTutorialsWithDictionary:(NSDictionary *)dict;
-(void) addTutorialsWithFile:(NSString *)fileName;

-(TutorialBalloonDescription *) unseenTutorialBalloonDescriptionForLevel:(NSString *)levelName;
-(TutorialStripDescription *) unseenTutorialStripDescriptionForLevel:(NSString *)levelName;
-(TutorialStripDescription *) unseenTutorialStripDescriptionForBeeType:(BeeType *)beeType;
-(TutorialDescription *) getTutorialDescription:(NSString *)id;

@end
