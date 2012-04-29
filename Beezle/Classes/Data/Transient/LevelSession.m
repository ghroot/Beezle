//
//  LevelSession.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSession.h"
#import "PollenComponent.h"

#define POLLEN_PER_UNUSED_BEE 20

@implementation LevelSession

@synthesize levelName = _levelName;
@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;
@synthesize numberOfUnusedBees = _numberOfUnusedBees;

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

-(void) consumedPollenEntity:(Entity *)pollenEntity
{
	_numberOfCollectedPollen += [[PollenComponent getFrom:pollenEntity] pollenCount];
}

-(int) totalNumberOfPollen
{
	return _numberOfCollectedPollen + POLLEN_PER_UNUSED_BEE * _numberOfUnusedBees;
}

@end
