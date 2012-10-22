//
//  PollenSystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 10/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PollenSystem.h"
#import "NotificationProcessor.h"
#import "PollenComponent.h"
#import "NotificationTypes.h"
#import "TransformComponent.h"
#import "RenderSystem.h"
#import "LevelSession.h"

@interface PollenSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) spawnPollenPickupLabel:(Entity *)pollenEntity;

@end

@implementation PollenSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithUsedComponentClass:[PollenComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];

		_levelSession = levelSession;
	}
	return self;
}

-(void) dealloc
{
	[_transformComponentMapper release];
	[_pollenComponentMapper release];

	[_notificationProcessor release];

	[super dealloc];
}

-(void) initialise
{
	_renderSystem = [[_world systemManager] getSystem:[RenderSystem class]];

	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
	_pollenComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PollenComponent class]];
}

-(void) activate
{
	[super activate];

	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];

	[_notificationProcessor deactivate];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[PollenComponent class]])
	{
		[self collectPollen:entity];
	}
}

-(void) collectPollen:(Entity *)entity
{
	[_levelSession consumedPollenEntity:entity];
	[self spawnPollenPickupLabel:entity];
}

-(void) spawnPollenPickupLabel:(Entity *)pollenEntity
{
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:pollenEntity];
	PollenComponent *pollenComponent = [_pollenComponentMapper getComponentFor:pollenEntity];

	NSString *pollenString = [NSString stringWithFormat:@"%d", [pollenComponent pollenCount]];
	CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"numberImages-s.png" itemWidth:15 itemHeight:18 startCharMap:'/'] autorelease];
	[label setString:pollenString];
	[label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[label setPosition:CGPointMake([transformComponent position].x + [pollenComponent pickupLabelOffset].x, [transformComponent position].y + [pollenComponent pickupLabelOffset].y)];
	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.8f scale:1.2f];
	CCFadeOut *fadeAction = [CCFadeOut actionWithDuration:0.8f];
	CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
		[[_renderSystem layer] removeChild:label cleanup:TRUE];
	}];
	CCSequence *sequence = [CCSequence actionOne:fadeAction two:removeAction];
	[label runAction:scaleAction];
	[label runAction:sequence];
	[[_renderSystem layer] addChild:label z:100];
}

@end
