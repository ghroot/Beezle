//
//  DebugSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugSystem.h"
#import "TransformComponent.h"

@implementation DebugSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[TransformComponent class]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	[TransformComponent getFrom:entity];
}

@end
