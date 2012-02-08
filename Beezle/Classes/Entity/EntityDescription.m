//
//  EntityDescription.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescription.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "DisposableComponent.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "TrajectoryComponent.h"

@implementation EntityDescription

@synthesize type = _type;
@synthesize groups = _groups;
@synthesize labels = _labels;
@synthesize tags = _tags;
@synthesize componentsDict = _componentsDict;

-(NSArray *) createComponents:(World *)world
{
	NSMutableArray *components = [NSMutableArray array];
	for (NSString *componentType in [_componentsDict allKeys])
	{
		Component *component = nil;
		NSDictionary *componentDict = [_componentsDict objectForKey:componentType];
		if ([componentType isEqualToString:@"bee"])
		{
			component = [BeeComponent component];
		}
		else if ([componentType isEqualToString:@"beeater"])
		{
			component = [BeeaterComponent component];
		}
		else if ([componentType isEqualToString:@"disposable"])
		{
			component = [DisposableComponent component];
		}
		else if ([componentType isEqualToString:@"movement"])
		{
			component = [MovementComponent componentFromDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"physics"])
		{
			component = [PhysicsComponent componentFromDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"render"])
		{
			component = [RenderComponent componentFromDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"slinger"])
		{
			component = [SlingerComponent component];
		}
		else if ([componentType isEqualToString:@"trajectory"])
		{
			component = [TrajectoryComponent component];
		}
		else if ([componentType isEqualToString:@"transform"])
		{
			component = [TransformComponent componentFromDictionary:componentDict world:world];
		}
		if (component != nil)
		{
			[components addObject:component];
		}
	}
	return components;
}

@end
