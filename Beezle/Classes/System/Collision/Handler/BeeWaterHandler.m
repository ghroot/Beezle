//
//  BeeWaterHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWaterHandler.h"
#import "Collision.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TransformComponent.h"

@implementation BeeWaterHandler

+(id) handlerWithWorld:(World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

-(id) initWithWorld:(World *)world
{
    if (self = [super init])
    {
        _world = world;
    }
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    
	Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Bees-Animations.plist"];
	TransformComponent *beeTransformComponent = [TransformComponent getFrom:beeEntity];
	[EntityUtil setEntityPosition:splashEntity position:[beeTransformComponent position]];
	[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Bee-Splash"];
	
	[beeEntity deleteEntity];
    
    return TRUE;
}

@end
