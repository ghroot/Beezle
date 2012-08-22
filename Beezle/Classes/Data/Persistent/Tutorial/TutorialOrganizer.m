//
//  TutorialOrganizer.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/09/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialOrganizer.h"
#import "TutorialBalloonDescription.h"
#import "TutorialTriggerDescription.h"
#import "TutorialBeeTypeTriggerDescription.h"
#import "BeeType.h"
#import "TutorialLevelTriggerDescription.h"
#import "TutorialEntityTypeTriggerDescription.h"
#import "TutorialStripDescription.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"

@interface TutorialOrganizer()

-(BOOL) isTutorialDescriptionTriggered:(TutorialDescription *)tutorialDescription levelName:(NSString *)levelName;

@end

@implementation TutorialOrganizer

@synthesize tutorialDescriptions = _tutorialDescriptions;

+(TutorialOrganizer *) sharedOrganizer
{
	static TutorialOrganizer *organizer = 0;
	if (!organizer)
	{
		organizer = [[self alloc] init];
	}
	return organizer;
}

-(id) init
{
	if (self = [super init])
	{
		_tutorialDescriptions = [NSMutableArray new];

		[self addTutorialsWithFile:@"Tutorial.plist"];
	}
	return self;
}

-(void) dealloc
{
	[_tutorialDescriptions release];

	[super dealloc];
}

-(void) addTutorialsWithDictionary:(NSDictionary *)dict
{
	NSArray *tutorialDicts = [dict objectForKey:@"tutorials"];
	for (NSDictionary *tutorialDict in tutorialDicts)
	{
		TutorialDescription *tutorialDescription = nil;

		NSString *id = [tutorialDict objectForKey:@"id"];

		NSDictionary *triggerDict = [tutorialDict objectForKey:@"trigger"];
		NSString *triggerType = [triggerDict objectForKey:@"type"];
		TutorialTriggerDescription *triggerDescription = nil;
		if ([triggerType isEqualToString:@"bee"])
		{
			NSString *beeTypeAsString = [triggerDict objectForKey:@"beeType"];
			BeeType *beeType = [BeeType enumFromName:beeTypeAsString];
			triggerDescription = [[[TutorialBeeTypeTriggerDescription alloc] initWithBeeType:beeType] autorelease];
		}
		else if ([triggerType isEqualToString:@"level"])
		{
			NSString *levelName = [triggerDict objectForKey:@"levelName"];
			triggerDescription = [[[TutorialLevelTriggerDescription alloc] initWithLevelName:levelName] autorelease];
		}
		else if ([triggerType isEqualToString:@"entity"])
		{
			NSString *entityType = [triggerDict objectForKey:@"entityType"];
			triggerDescription = [[[TutorialEntityTypeTriggerDescription alloc] initWithEntityType:entityType] autorelease];
		}

		NSString *type = [tutorialDict objectForKey:@"type"];
		if ([type isEqualToString:@"balloon"])
		{
			NSString *frameName = [tutorialDict objectForKey:@"frameName"];
			tutorialDescription = [[[TutorialBalloonDescription alloc] initWithId:id trigger:triggerDescription andFrameName:frameName] autorelease];
		}
		else if ([type isEqualToString:@"strip"])
		{
			NSString *fileName = [tutorialDict objectForKey:@"fileName"];
			tutorialDescription = [[[TutorialStripDescription alloc] initWithId:id trigger:triggerDescription andFileName:fileName] autorelease];
		}

		if (tutorialDescription != nil)
		{
			[_tutorialDescriptions addObject:tutorialDescription];
		}
	}
}

-(void) addTutorialsWithFile:(NSString *)fileName
{
	NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

	[self addTutorialsWithDictionary:dict];
}

-(TutorialBalloonDescription *) tutorialBalloonDescriptionForLevel:(NSString *)levelName
{
	for (TutorialDescription *tutorialDescription in _tutorialDescriptions)
	{
		if ([tutorialDescription isKindOfClass:[TutorialBalloonDescription class]] &&
			[self isTutorialDescriptionTriggered:tutorialDescription levelName:levelName])
		{
			return (TutorialBalloonDescription *)tutorialDescription;
		}
	}
	return nil;
}

-(TutorialStripDescription *) tutorialStripDescriptionForLevel:(NSString *)levelName
{
	for (TutorialDescription *tutorialDescription in _tutorialDescriptions)
	{
		if ([tutorialDescription isKindOfClass:[TutorialStripDescription class]] &&
			[self isTutorialDescriptionTriggered:tutorialDescription levelName:levelName])
		{
			return (TutorialStripDescription *)tutorialDescription;
		}
	}
	return nil;
}

-(BOOL) isTutorialDescriptionTriggered:(TutorialDescription *)tutorialDescription levelName:(NSString *)levelName
{
	TutorialTriggerDescription *tutorialTriggerDescription = [tutorialDescription triggerDescription];
	if ([tutorialTriggerDescription isKindOfClass:[TutorialLevelTriggerDescription class]])
	{
		TutorialLevelTriggerDescription *tutorialLevelTriggerDescription = (TutorialLevelTriggerDescription *)tutorialTriggerDescription;
		if ([[tutorialLevelTriggerDescription levelName] isEqualToString:levelName])
		{
			return TRUE;
		}
	}
	else if ([tutorialTriggerDescription isKindOfClass:[TutorialEntityTypeTriggerDescription class]])
	{
		TutorialEntityTypeTriggerDescription *tutorialEntityTypeTriggerDescription = (TutorialEntityTypeTriggerDescription *)tutorialTriggerDescription;
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
		{
			if ([[levelLayoutEntry type] isEqualToString:[tutorialEntityTypeTriggerDescription entityType]])
			{
				return TRUE;
			}
		}
	}
	else if ([tutorialTriggerDescription isKindOfClass:[TutorialBeeTypeTriggerDescription class]])
	{
		TutorialBeeTypeTriggerDescription *tutorialBeeTypeTriggerDescription = (TutorialBeeTypeTriggerDescription *)tutorialTriggerDescription;
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
		{
			if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
			{
				NSDictionary *slingerComponentDictionary = [[levelLayoutEntry instanceComponentsDict] objectForKey:@"slinger"];
				for (NSString *beeTypeAsString in [slingerComponentDictionary objectForKey:@"queuedBeeTypes"])
				{
					BeeType *beeType = [BeeType enumFromName:beeTypeAsString];
					if ([tutorialBeeTypeTriggerDescription beeType] == beeType)
					{
						return TRUE;
					}
				}
			}
			else if ([[levelLayoutEntry instanceComponentsDict] objectForKey:@"captured"] != nil)
			{
				NSDictionary *capturedInstanceComponentDict = [[levelLayoutEntry instanceComponentsDict] objectForKey:@"captured"];
				NSString *containedBeeTypeAsString = [capturedInstanceComponentDict objectForKey:@"containedBeeType"];
				BeeType *capturedBeeType = [BeeType enumFromName:containedBeeTypeAsString];
				if (capturedBeeType == [tutorialBeeTypeTriggerDescription beeType])
				{
					return TRUE;
				}
			}
		}
	}
	return FALSE;
}

@end
