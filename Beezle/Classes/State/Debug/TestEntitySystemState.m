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
	[_label setPosition:[Utils getScreenCenterPosition]];
	[self addChild:_label];
	
    [[_world systemManager] setSystem:[DebugSystem system]];
    [[_world systemManager] initialiseAll];
    
	Entity *entity = [_world createEntity];
	[entity addComponent:[TransformComponent component]];
	[entity refresh];
}

-(void) update:(ccTime)delta
{	
	[_world loopStart];
	[_world setDelta:(int)(1000.0f * delta)];
	
	NSDate *startTime = [NSDate date];
    
	for (int i = 0; i < 100000; i++)
	{
		[[_world systemManager] processAll];
	}
	
	NSDate *endTime = [NSDate date];
	NSTimeInterval duration = [endTime timeIntervalSinceDate:startTime];
	[_label setString:[NSString stringWithFormat:@"%f", duration]];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	[_game popState];
    return TRUE;
}

@end
