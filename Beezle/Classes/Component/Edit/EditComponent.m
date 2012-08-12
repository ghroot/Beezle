//
//  EditComponent.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditComponent.h"

@implementation EditComponent

@synthesize levelLayoutType = _levelLayoutType;
@synthesize nextMovementIndicatorEntity = _nextMovementIndicatorEntity;
@synthesize mainMoveEntity = _mainMoveEntity;
@synthesize teleportOutPositionEntity = _teleportOutPositionEntity;
@synthesize mainTeleportEntity = _mainTeleportEntity;

+(EditComponent *) componentWithLevelLayoutType:(NSString *)levelLayoutType
{
	return [[[self alloc] initWithLevelLayoutType:levelLayoutType] autorelease];
}

// Designated initialiser
-(id) initWithLevelLayoutType:(NSString *)levelLayoutType
{
	if (self = [super init])
	{
		_levelLayoutType = [levelLayoutType copy];
	}
	return self;
}

-(id) init
{
	return [self initWithLevelLayoutType:nil];
}

-(void) dealloc
{
	[_levelLayoutType release];
	
	[super dealloc];
}

@end
