//
//  LevelSession.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSession.h"
#import "KeyComponent.h"
#import "PollenComponent.h"

#define POLLEN_PER_UNUSED_BEE 20

@implementation LevelSession

@synthesize levelName = _levelName;
@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;
@synthesize numberOfUnusedBees = _numberOfUnusedBees;
@synthesize didCollectKey = _didCollectKey;
@synthesize didUseKey = _didUseKey;

-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
	{
		_levelName = [levelName copy];
	}
	return self;
}

-(void) dealloc
{
	[_levelName release];
	
	[super dealloc];
}

-(void) consumedEntity:(Entity *)entity
{	
	if ([entity hasComponent:[PollenComponent class]])
	{
		_numberOfCollectedPollen += [[PollenComponent getFrom:entity] pollenCount];
	}
	if ([entity hasComponent:[KeyComponent class]])
	{
		_didCollectKey = TRUE;
	}
}

-(int) totalNumberOfPollen
{
	return _numberOfCollectedPollen + POLLEN_PER_UNUSED_BEE * _numberOfUnusedBees;
}

@end
