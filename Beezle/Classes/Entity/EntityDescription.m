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
#import "CollisionComponent.h"
#import "CrumbleComponent.h"
#import "DisposableComponent.h"
#import "DozerComponent.h"
#import "EdgeComponent.h"
#import "ExplodeComponent.h"
#import "GateComponent.h"
#import "HealthComponent.h"
#import "KeyComponent.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "PollenComponent.h"
#import "RenderComponent.h"
#import "ShakeComponent.h"
#import "ShardComponent.h"
#import "SlingerComponent.h"
#import "SoundComponent.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"
#import "TrajectoryComponent.h"
#import "WaterComponent.h"
#import "WoodComponent.h"

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
			component = [BeeComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"beeater"])
		{
			component = [BeeaterComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"collision"])
		{
			component = [CollisionComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"crumble"])
		{
			component = [CrumbleComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"disposable"])
		{
			component = [DisposableComponent componentWithContentsOfDictionary:componentDict world:world];
		}
        else if ([componentType isEqualToString:@"dozer"])
		{
			component = [DozerComponent componentWithContentsOfDictionary:componentDict world:world];
		}
        else if ([componentType isEqualToString:@"edge"])
		{
			component = [EdgeComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"explode"])
		{
			component = [ExplodeComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"gate"])
		{
			component = [GateComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"health"])
		{
			component = [HealthComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"key"])
		{
			component = [KeyComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"movement"])
		{
			component = [MovementComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"physics"])
		{
			component = [PhysicsComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"pollen"])
		{
			component = [PollenComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"render"])
		{
			component = [RenderComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"shake"])
		{
			component = [ShakeComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"shard"])
		{
			component = [ShardComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"slinger"])
		{
			component = [SlingerComponent componentWithContentsOfDictionary:componentDict world:world];
		}
        else if ([componentType isEqualToString:@"sound"])
		{
			component = [SoundComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"spawn"])
		{
			component = [SpawnComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"trajectory"])
		{
			component = [TrajectoryComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"transform"])
		{
			component = [TransformComponent componentWithContentsOfDictionary:componentDict world:world];
		}
        else if ([componentType isEqualToString:@"water"])
		{
			component = [WaterComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"wood"])
		{
			component = [WoodComponent componentWithContentsOfDictionary:componentDict world:world];
		}
		if (component != nil)
		{
			[components addObject:component];
		}
	}
	return components;
}

@end
