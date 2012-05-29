//
//  MovementComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementComponent.h"

@implementation MovementComponent

@synthesize positions = _positions;
@synthesize alwaysFaceForward = _alwaysFaceForward;
@synthesize isMovingPaused = _isMovingPaused;
@synthesize currentPositionIndex = _currentPositionIndex;
@synthesize isMovingForwardInPositionList = _isMovingForwardInPositionList;
@synthesize startPosition = _startPosition;
@synthesize isMovingTowardsStartPosition = _isMovingTowardsStartPosition;

-(id) init
{
	if (self = [super init])
	{
		_positions = [[NSArray alloc] init];
		_alwaysFaceForward = FALSE;
		_isMovingForwardInPositionList = TRUE;
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        if ([typeComponentDict objectForKey:@"alwaysFaceForward"] != nil)
        {
            _alwaysFaceForward = [[typeComponentDict objectForKey:@"alwaysFaceForward"] boolValue];
        }
        
        // Instance
        NSArray *positionsAsStrings = [instanceComponentDict objectForKey:@"positions"];
        NSMutableArray *positions = [NSMutableArray array];
        for (NSString *positionAsString in positionsAsStrings)
        {
            CGPoint position = CGPointFromString(positionAsString);
            [positions addObject:[NSValue valueWithCGPoint:position]];
        }
        [self setPositions:positions];
	}
	return self;
}

-(void) dealloc
{
	[_positions release];
	
	[super dealloc];
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	
	NSMutableArray *positionsAsStrings = [NSMutableArray array];
    for (NSValue *positionAsValue in _positions)
    {
        [positionsAsStrings addObject:NSStringFromCGPoint([positionAsValue CGPointValue])];
    }
	[instanceComponentDict setObject:positionsAsStrings forKey:@"positions"];
	
	return instanceComponentDict;
}

@end
