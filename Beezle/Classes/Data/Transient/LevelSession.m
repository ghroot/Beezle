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

@implementation LevelSession

@synthesize levelName = _levelName;
@synthesize numberOfCollectedPollen = _numberOfCollectedPollen;
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

@end
