//
//  BeeGateHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeGateHandler.h"
#import "Collision.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"

@implementation BeeGateHandler

+(id) handlerWithLevelSession:(LevelSession *)levelSession
{
    return [[[self alloc] initWithLevelSession:levelSession] autorelease];
}

-(id) initWithLevelSession:(LevelSession *)levelSession
{
    if (self = [super init])
    {
        _levelSession = levelSession;
    }
    return self;
}

-(void) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *gateEntity = [collision secondEntity];
    
	GateComponent *gateComponent = [GateComponent getFrom:gateEntity];
	if ([gateComponent isOpened])
	{
		[_levelSession setDidUseKey:TRUE];
		
        [[PhysicsComponent getFrom:beeEntity] disable];
		[[[RenderComponent getFrom:beeEntity] firstRenderSprite] hide];
		
		// Game notification
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:nil];
	}
}

@end
