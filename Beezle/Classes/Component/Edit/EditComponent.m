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

+(EditComponent *) componentWithLevelLayoutType:(NSString *)levelLayoutType
{
	return [[[self alloc] initWithLevelLayoutType:levelLayoutType] autorelease];
}

// Designated initialiser
-(id) initWithLevelLayoutType:(NSString *)levelLayoutType
{
	if (self = [super init])
	{
		_levelLayoutType = [levelLayoutType retain];
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
