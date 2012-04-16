//
//  WaterDropHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterDropHandler.h"
#import "Collision.h"
#import "CollisionType.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "TransformComponent.h"
#import "SoundManager.h"

@implementation WaterDropHandler

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world andLevelSession:levelSession])
    {
        _firstCollisionType = [CollisionType WATER_DROP];
        [_secondCollisionTypes addObject:[CollisionType BACKGROUND]];
        [_secondCollisionTypes addObject:[CollisionType WATER]];
    }
    return self;
}

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *waterdropEntity = [collision firstEntity];
    
	[EntityUtil setEntityDisposed:waterdropEntity];
	
	Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world];
	TransformComponent *transforComponent = [TransformComponent getFrom:waterdropEntity];
	[EntityUtil setEntityPosition:splashEntity position:[transforComponent position]];
	[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Waterdrop-Splash"];
	
	NSString *soundName = [NSString stringWithFormat:@"DripSmall%d", (1 + (rand() % 2))];
	[[SoundManager sharedManager] playSound:soundName];
    
    return FALSE;
}

@end
