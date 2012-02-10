//
//  TrailSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrailSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TrailComponent.h"
#import "TransformComponent.h"

@implementation TrailSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[TrailComponent class]]];
	return self;
}

-(void) entityAdded:(Entity *)entity
{
	TrailComponent *trailComponent = [TrailComponent getFrom:entity];
	[trailComponent resetCountdown];
}

-(void) processEntity:(Entity *)entity
{
	TrailComponent *trailComponent = [TrailComponent getFrom:entity];
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	
	[trailComponent setCountdown:[trailComponent countdown] - ([_world delta] / 1000.0f)];
	if ([trailComponent countdown] <= 0)
	{
		Entity *entity = [EntityFactory createEntity:[trailComponent entityType] world:_world];
		[EntityUtil setEntityPosition:entity position:[transformComponent position]];
		[EntityUtil animateAndDeleteEntity:entity animationName:[trailComponent animationName] disablePhysics:TRUE];
		
		[trailComponent resetCountdown];
	}
}

@end
