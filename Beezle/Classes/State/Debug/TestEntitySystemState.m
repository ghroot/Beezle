//
//  TestEntitySystemState.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestEntitySystemState.h"
#import "DebugSystem.h"
#import "Game.h"
#import "TransformComponent.h"
#import "Utils.h"

@implementation TestEntitySystemState

-(id) init
{
	if (self = [super init])
	{
		_world = [World new];
	}
	return self;
}

-(void) dealloc
{
	[_world release];
	
	[super dealloc];
}

-(void) initialise
{
    [super initialise];
	
	_label = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:30.0f];
	[_label setAnchorPoint:CGPointMake(0.5f, 0.0f)];
	[_label setPosition:[Utils screenCenterPosition]];
	[self addChild:_label];

	_label2 = [CCLabelTTF labelWithString:@"Slow" fontName:@"Marker Felt" fontSize:30.0f];
	[_label2 setAnchorPoint:CGPointMake(0.5f, 1.0f)];
	[_label2 setPosition:[Utils screenCenterPosition]];
	[self addChild:_label2];

    [[_world systemManager] setSystem:[DebugSystem system]];
    [[_world systemManager] initialiseAll];

	for (int i = 0; i < 100; i++)
	{
		Entity *entity = [_world createEntity];
		[entity addComponent:[TransformComponent component]];
		[entity refresh];
	}
}

-(void) update:(ccTime)delta
{	
	[_world loopStart];
	[_world setDelta:(int)(1000.0f * delta)];

	NSDate *startTime = [NSDate date];

	[[_world systemManager] processAll];

	NSDate *endTime = [NSDate date];
	NSTimeInterval duration = [endTime timeIntervalSinceDate:startTime];
	[_label setString:[NSString stringWithFormat:@"%f", duration]];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	if (convertedLocation.x < winSize.width / 2)
	{
		[_game popState];
	}
	else
	{
		DebugSystem *debugSystem = (DebugSystem *)[[_world systemManager] getSystem:[DebugSystem class]];
		[debugSystem setSlow:![debugSystem slow]];
		if ([debugSystem slow])
		{
			[_label2 setString:@"Slow"];
		}
		else
		{
			[_label2 setString:@"Fast"];
		}
	}
    return TRUE;
}

@end
