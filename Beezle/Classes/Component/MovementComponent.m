//
//  MovementComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementComponent.h"
#import "Utils.h"

@implementation MovementComponent

@synthesize positions = _positions;
@synthesize alwaysFaceForward = _alwaysFaceForward;
@synthesize currentPositionIndex = _currentPositionIndex;
@synthesize isMovingForwardInPositionList = _isMovingForwardInPositionList;
@synthesize startPosition = _startPosition;
@synthesize isMovingTowardsStartPosition = _isMovingTowardsStartPosition;

+(MovementComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

// Designated initializer
-(id) init
{
	if (self = [super init])
	{
		_name = @"movement";
		_positions = [[NSArray alloc] init];
		_alwaysFaceForward = FALSE;
		_isMovingForwardInPositionList = TRUE;
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"alwaysFaceForward"] != nil)
		{
			_alwaysFaceForward = [[dict objectForKey:@"alwaysFaceForward"] boolValue];
		}
	}
	return self;
}

-(void) dealloc
{
	[_positions release];
	
	[super dealloc];
}

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSMutableArray *positionsAsStrings = [NSMutableArray array];
	for (NSValue *positionAsValue in _positions)
	{
		[positionsAsStrings addObject:[Utils pointToString:[positionAsValue CGPointValue]]];
	}
	[dict setObject:positionsAsStrings forKey:@"positions"];
	return dict;
}

@end
