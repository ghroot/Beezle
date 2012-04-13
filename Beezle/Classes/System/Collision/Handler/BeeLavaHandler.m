//
//  BeeLavaHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 13/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeLavaHandler.h"
#import "BeeComponent.h"
#import "Collision.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TransformComponent.h"

@implementation BeeLavaHandler

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
	
	BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
    if ([beeComponent type] == [BeeType BOMBEE])
	{
		[EntityUtil animateAndDeleteEntity:beeEntity animationName:@"Bombee-Boom-Full"];
	}
	else if ([beeComponent type] == [BeeType SUMEE])
	{
		[EntityUtil animateAndDeleteEntity:beeEntity];
	}
	else
	{
		Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Bees-Animations.plist"];
		TransformComponent *beeTransformComponent = [TransformComponent getFrom:beeEntity];
		[EntityUtil setEntityPosition:splashEntity position:[beeTransformComponent position]];
		[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Bee-Splash-Lava"];
		
		[beeEntity deleteEntity];
	}

    return TRUE;
}

@end
