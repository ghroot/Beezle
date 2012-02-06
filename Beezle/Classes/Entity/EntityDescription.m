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
#import "CollisionType.h"
#import "DisposableComponent.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "TrajectoryComponent.h"
#import "Utils.h"

@interface EntityDescription()

-(TransformComponent *) createTransformComponent:(NSDictionary *)dict world:(World *)world;
-(RenderComponent *) createRenderComponent:(NSDictionary *)dict world:(World *)world;
-(PhysicsComponent *) createPhysicsComponent:(NSDictionary *)dict world:(World *)world;

@end

@implementation EntityDescription

@synthesize type = _type;
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
			component = [MovementComponent component];
		}
		else if ([componentType isEqualToString:@"physics"])
		{
			component = [self createPhysicsComponent:componentDict world:world];
		}
		else if ([componentType isEqualToString:@"render"])
		{
			component = [self createRenderComponent:componentDict world:world];
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
			component = [self createTransformComponent:componentDict world:world];
		}
		if (component != nil)
		{
			[components addObject:component];
		}
	}
	return components;
}

-(TransformComponent *) createTransformComponent:(NSDictionary *)dict world:(World *)world
{
	TransformComponent *transformComponent = [TransformComponent component];
	
	if ([dict objectForKey:@"scale"] != nil)
	{
		CGPoint scale = [Utils stringToPosition:[dict objectForKey:@"scale"]];
		[transformComponent setScale:scale];
	}
	
	return transformComponent;
}

-(RenderComponent *) createRenderComponent:(NSDictionary *)dict world:(World *)world
{
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderComponent *renderComponent = [RenderComponent component];
	for (NSDictionary *spriteDict in [dict objectForKey:@"sprites"])
	{
		NSString *name = [spriteDict objectForKey:@"name"];
		NSString *spriteSheetName = [spriteDict objectForKey:@"spriteSheetName"];
		NSString *animationFile = [spriteDict objectForKey:@"animationFile"];
		int z = [[spriteDict objectForKey:@"z"] intValue];
		CGPoint anchorPoint = [Utils stringToPosition:[spriteDict objectForKey:@"anchorPoint"]];
		NSString *defaultIdleAnimationName = [spriteDict objectForKey:@"defaultIdleAnimation"];
		
		RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName animationFile:animationFile z:z];
		[[renderSprite sprite] setAnchorPoint:anchorPoint];
		[renderComponent addRenderSprite:renderSprite withName:name];
		
		if (defaultIdleAnimationName != nil)
		{
			[renderSprite playAnimation:defaultIdleAnimationName];
		}
	}
	return renderComponent;
}

-(PhysicsComponent *) createPhysicsComponent:(NSDictionary *)dict world:(World *)world
{
	PhysicsComponent *physicsComponent = [PhysicsComponent component];
	
	NSDictionary *bodyDict = [dict objectForKey:@"body"];
	NSString *bodyType = [bodyDict objectForKey:@"type"];
	ChipmunkBody *body = nil;
	if ([bodyType isEqualToString:@"static"])
	{
		body = [ChipmunkBody staticBody];
	}
	else if ([bodyType isEqualToString:@"rouge"])
	{
		body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		[physicsComponent setIsRougeBody:TRUE];
	}
	else if ([bodyType isEqualToString:@"dynamic"])
	{
		float mass = [[bodyDict objectForKey:@"mass"] floatValue];
		float moment = [[bodyDict objectForKey:@"moment"] floatValue];
		body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
	}
	else
	{
		NSLog(@"Unknown body type: %@", bodyType);
	}
	[physicsComponent setBody:body];
	
	NSArray *shapeDicts = [dict objectForKey:@"shapes"];
	for (NSDictionary *shapeDict in shapeDicts)
	{
		NSString *shapeType = [shapeDict objectForKey:@"type"];
		float elasticity = [[shapeDict objectForKey:@"elasticity"] floatValue];
		float friction = [[shapeDict objectForKey:@"friction"] floatValue];
		CollisionType *collisionType = [CollisionType enumFromName:[shapeDict objectForKey:@"collisionType"]];
		CGPoint offset;
		if ([shapeDict objectForKey:@"offset"] != nil)
		{
			offset = [Utils stringToPosition:[shapeDict objectForKey:@"offset"]];
		}
		else
		{
			offset = CGPointZero;
		}
		
		ChipmunkShape *shape = nil;
		if ([shapeType isEqualToString:@"poly"])
		{
			NSArray *verticesAsStrings = [shapeDict objectForKey:@"vertices"];
			CGPoint verts[[verticesAsStrings count]];
			for (NSString *vertexAsString in verticesAsStrings)
			{
				CGPoint vert = [Utils stringToPosition:vertexAsString];
				verts[[verticesAsStrings indexOfObject:vertexAsString]] = vert;
			}
			shape = [ChipmunkPolyShape polyWithBody:body count:[verticesAsStrings count] verts:verts offset:offset];
		}
		else if ([shapeType isEqualToString:@"circle"])
		{
			float radius = [[shapeDict objectForKey:@"radius"] floatValue];
			shape = [ChipmunkCircleShape circleWithBody:body radius:radius offset:offset];
		}
		[shape setElasticity:elasticity];
		[shape setFriction:friction];
		[shape setCollisionType:collisionType];
		if ([shapeDict objectForKey:@"layers"] != nil)
		{
			[shape setLayers:[[shapeDict objectForKey:@"layers"] intValue]];
		}
		if ([shapeDict objectForKey:@"group"] != nil)
		{
			[shape setGroup:[CollisionType enumFromName:[shapeDict objectForKey:@"group"]]];
		}
		
		[physicsComponent addShape:shape];
	}
	
	return physicsComponent;
}

@end
