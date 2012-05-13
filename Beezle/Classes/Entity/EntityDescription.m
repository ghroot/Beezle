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
#import "BoostComponent.h"
#import "BreakableComponent.h"
#import "BrittleComponent.h"
#import "CapturedComponent.h"
#import "ConsumerComponent.h"
#import "CrumbleComponent.h"
#import "DisposableComponent.h"
#import "DozerComponent.h"
#import "ExplodeComponent.h"
#import "FreezableComponent.h"
#import "FreezeComponent.h"
#import "HealthComponent.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "PollenComponent.h"
#import "RenderComponent.h"
#import "SawComponent.h"
#import "ShakeComponent.h"
#import "ShardComponent.h"
#import "SlingerComponent.h"
#import "SolidComponent.h"
#import "SoundComponent.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"
#import "TrajectoryComponent.h"
#import "VoidComponent.h"
#import "VolatileComponent.h"
#import "WaterComponent.h"
#import "WobbleComponent.h"
#import "WoodComponent.h"

@implementation EntityDescription

@synthesize type = _type;
@synthesize groups = _groups;
@synthesize labels = _labels;
@synthesize tags = _tags;
@synthesize typeComponentsDict = _typeComponentsDict;

-(NSArray *) createComponents:(World *)world instanceComponentsDict:(NSDictionary *)instanceComponentsDict
{
	NSMutableArray *components = [NSMutableArray array];
	for (NSString *componentType in [_typeComponentsDict allKeys])
	{
		Component *component = nil;
		
		NSDictionary *typeComponentDict = [_typeComponentsDict objectForKey:componentType];
		
		if ([componentType isEqualToString:@"bee"])
		{
			component = [BeeComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"beeater"])
		{
			component = [BeeaterComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"boost"])
		{
			component = [BoostComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"breakable"])
		{
			component = [BreakableComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"brittle"])
		{
			component = [BrittleComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"captured"])
		{
			component = [CapturedComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"consumer"])
		{
			component = [ConsumerComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"crumble"])
		{
			component = [CrumbleComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"disposable"])
		{
			component = [DisposableComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"dozer"])
		{
			component = [DozerComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"explode"])
		{
			component = [ExplodeComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"freeze"])
		{
			component = [FreezeComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"freezable"])
		{
			component = [FreezableComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"health"])
		{
			component = [HealthComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"movement"])
		{
			component = [MovementComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"physics"])
		{
			component = [PhysicsComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"pollen"])
		{
			component = [PollenComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"render"])
		{
			component = [RenderComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"saw"])
		{
			component = [SawComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"shake"])
		{
			component = [ShakeComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"shard"])
		{
			component = [ShardComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"slinger"])
		{
			component = [SlingerComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"solid"])
		{
			component = [SolidComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"sound"])
		{
			component = [SoundComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"spawn"])
		{
			component = [SpawnComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"trajectory"])
		{
			component = [TrajectoryComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"transform"])
		{
			component = [TransformComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"void"])
		{
			component = [VoidComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"volatile"])
		{
			component = [VolatileComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"water"])
		{
			component = [WaterComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"wobble"])
		{
			component = [WobbleComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"wood"])
		{
			component = [WoodComponent componentWithContentsOfDictionary:typeComponentDict world:world];
		}
		
		if (component != nil)
		{
			NSDictionary *instanceComponentDict = [instanceComponentsDict objectForKey:componentType];
			if (instanceComponentDict != nil)
			{
				[component populateWithContentsOfDictionary:instanceComponentDict world:world];
			}
			
			[components addObject:component];
		}
		else
		{
			NSLog(@"WARNING: Unknown component type: %@", componentType);
		}
	}
	return components;
}

@end
