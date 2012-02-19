//
//  MovementComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementComponent.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TransformComponent.h"
#import "Utils.h"

@implementation MovementComponent

@synthesize positions = _positions;
@synthesize alwaysFaceForward = _alwaysFaceForward;
@synthesize currentPositionIndex = _currentPositionIndex;
@synthesize isMovingForwardInPositionList = _isMovingForwardInPositionList;
@synthesize startPosition = _startPosition;
@synthesize isMovingTowardsStartPosition = _isMovingTowardsStartPosition;

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
	
	if (CONFIG_CAN_EDIT_LEVELS &&
		[_parentEntity hasComponent:[EditComponent class]])
	{
		Entity *currentMovementIndicatorEntity = [[EditComponent getFrom:_parentEntity] nextMovementIndicatorEntity];
		while (currentMovementIndicatorEntity != nil)
		{
			TransformComponent *currentTransformComponent = [TransformComponent getFrom:currentMovementIndicatorEntity];
			EditComponent *currentEditComponent = [EditComponent getFrom:currentMovementIndicatorEntity];
			
			[positionsAsStrings addObject:[Utils pointToString:[currentTransformComponent position]]];
			
			currentMovementIndicatorEntity = [currentEditComponent nextMovementIndicatorEntity];
		}
	}
	else
	{
		for (NSValue *positionAsValue in _positions)
		{
			[positionsAsStrings addObject:[Utils pointToString:[positionAsValue CGPointValue]]];
		}
	}
	
	[dict setObject:positionsAsStrings forKey:@"positions"];
	
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	[self populateWithContentsOfDictionary:dict world:world edit:FALSE];
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world edit:(BOOL)edit
{
	if ([dict objectForKey:@"positions"] != nil)
	{
		NSArray *positionsAsStrings = [dict objectForKey:@"positions"];
		NSMutableArray *positions = [NSMutableArray array];
		for (NSString *positionAsString in positionsAsStrings)
		{
			CGPoint position = [Utils stringToPoint:positionAsString];
			[positions addObject:[NSValue valueWithCGPoint:position]];
		}
		[self setPositions:positions];
		
		if (CONFIG_CAN_EDIT_LEVELS && edit)
		{
			// Create movement indicator entities to allow for editing
			EditComponent *currentEditComponent = [EditComponent getFrom:_parentEntity];
			for (NSValue *movePositionAsValue in _positions)
			{
				Entity *movementIndicator = [EntityFactory createMovementIndicator:world forEntity:_parentEntity];
				[EntityUtil setEntityPosition:movementIndicator position:[movePositionAsValue CGPointValue]];
				[currentEditComponent setNextMovementIndicatorEntity:movementIndicator];
				[currentEditComponent setMainMoveEntity:_parentEntity];
				currentEditComponent = [EditComponent getFrom:movementIndicator];
			}
			[currentEditComponent setMainMoveEntity:_parentEntity];
		}
	}
}

@end
