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
        NSDictionary *instanceComponentDict = [instanceComponentsDict objectForKey:componentType];
		
		if ([componentType isEqualToString:@"bee"])
		{
			component = [BeeComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"beeater"])
		{
			component = [BeeaterComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"boost"])
		{
			component = [BoostComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"breakable"])
		{
			component = [BreakableComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"brittle"])
		{
			component = [BrittleComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"captured"])
		{
			component = [CapturedComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"consumer"])
		{
			component = [ConsumerComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"crumble"])
		{
			component = [CrumbleComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"disposable"])
		{
			component = [DisposableComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"dozer"])
		{
			component = [DozerComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"explode"])
		{
			component = [ExplodeComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"freeze"])
		{
			component = [FreezeComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"freezable"])
		{
			component = [FreezableComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"health"])
		{
			component = [HealthComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"movement"])
		{
			component = [MovementComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"physics"])
		{
			component = [PhysicsComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"pollen"])
		{
			component = [PollenComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"render"])
		{
			component = [RenderComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"saw"])
		{
			component = [SawComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"shake"])
		{
			component = [ShakeComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"shard"])
		{
			component = [ShardComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"slinger"])
		{
			component = [SlingerComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"solid"])
		{
			component = [SolidComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"sound"])
		{
			component = [SoundComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"spawn"])
		{
			component = [SpawnComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"trajectory"])
		{
			component = [TrajectoryComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"transform"])
		{
			component = [TransformComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"void"])
		{
			component = [VoidComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"volatile"])
		{
			component = [VolatileComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
        else if ([componentType isEqualToString:@"water"])
		{
			component = [WaterComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"wobble"])
		{
			component = [WobbleComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		else if ([componentType isEqualToString:@"wood"])
		{
			component = [WoodComponent componentWithTypeComponentDict:typeComponentDict andInstanceComponentDict:instanceComponentDict world:world];
		}
		
		if (component != nil)
		{
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
