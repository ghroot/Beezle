//
//  CullingSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 14/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CullingSystem.h"
#import "DisposableComponent.h"

@implementation CullingSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[DisposableComponent class]]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
	if ([disposableComponent isDisposed] &&
		[disposableComponent destroyEntityWhenDisposed])
	{
		[entity deleteEntity];
	}
}

@end
