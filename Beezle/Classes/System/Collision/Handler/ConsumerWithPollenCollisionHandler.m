//
//  ConsumerWithPollenCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConsumerWithPollenCollisionHandler.h"
#import "ConsumerComponent.h"
#import "LevelSession.h"
#import "PollenComponent.h"
#import "RenderSystem.h"
#import "EntityUtil.h"
#import "DisposableComponent.h"
#import "TransformComponent.h"

@interface ConsumerWithPollenCollisionHandler()

-(void) spawnPollenPickupLabel:(Entity *)pollenEntity;

@end

@implementation ConsumerWithPollenCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[ConsumerComponent class]];
		[_secondComponentClasses addObject:[PollenComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *pollenEntity = secondEntity;

	if ([EntityUtil isEntityDisposable:pollenEntity] &&
		[[DisposableComponent getFrom:pollenEntity] isAboutToBeDeleted])
	{
		return TRUE;
	}
	
	[_levelSession consumedPollenEntity:pollenEntity];
	
	[self spawnPollenPickupLabel:pollenEntity];
	
	return TRUE;
}

-(void) spawnPollenPickupLabel:(Entity *)pollenEntity
{
	RenderSystem *renderSystem = (RenderSystem *)[[_world systemManager] getSystem:[RenderSystem class]];
	TransformComponent *transformComponent = [TransformComponent getFrom:pollenEntity];
	PollenComponent *pollenComponent = [PollenComponent getFrom:pollenEntity];

	NSString *pollenString = [NSString stringWithFormat:@"%d", [pollenComponent pollenCount]];
	CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"numberImages-s.png" itemWidth:15 itemHeight:18 startCharMap:'/'] autorelease];
	[label setString:pollenString];
	[label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[label setPosition:CGPointMake([transformComponent position].x + [pollenComponent pickupLabelOffset].x, [transformComponent position].y + [pollenComponent pickupLabelOffset].y)];
	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.8f scale:1.2f];
	CCFadeOut *fadeAction = [CCFadeOut actionWithDuration:0.8f];
	CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
		[[renderSystem layer] removeChild:label cleanup:TRUE];
	}];
	CCSequence *sequence = [CCSequence actionOne:fadeAction two:removeAction];
	[label runAction:scaleAction];
	[label runAction:sequence];
	[[renderSystem layer] addChild:label z:100];
}

@end
