//
//  WaterDropHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterDropHandler.h"
#import "Collision.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TransformComponent.h"
#import "SoundManager.h"

@implementation WaterDropHandler

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

-(void) handleCollision:(Collision *)collision
{
    Entity *waterdropEntity = [collision firstEntity];
    
	if (![EntityUtil isEntityDisposed:waterdropEntity])
	{
		[EntityUtil setEntityDisposed:waterdropEntity];
		[waterdropEntity deleteEntity];
		
		Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world];
		TransformComponent *transforComponent = [TransformComponent getFrom:waterdropEntity];
		[EntityUtil setEntityPosition:splashEntity position:[transforComponent position]];
		[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Waterdrop-Splash"];
		
		NSString *soundName = [NSString stringWithFormat:@"DripSmall%d", (1 + (rand() % 2))];
		[[SoundManager sharedManager] playSound:soundName];
	}
}

@end
