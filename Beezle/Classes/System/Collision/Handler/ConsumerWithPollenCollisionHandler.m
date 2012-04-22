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
	[_levelSession consumedPollenEntity:pollenEntity];
	return TRUE;
}

@end
