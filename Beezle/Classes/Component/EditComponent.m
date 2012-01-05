//
//  EditableComponent.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditComponent.h"

@implementation EditComponent

@synthesize levelLayoutType = _levelLayoutType;
@synthesize isSelected = _isSelected;

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
		_isSelected = FALSE;
	}
	return self;
}

-(id) init
{
	return [self initWithLevelLayoutType:nil];
}

@end
