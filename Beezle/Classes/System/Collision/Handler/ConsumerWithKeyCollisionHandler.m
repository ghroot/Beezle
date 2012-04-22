//
//  ConsumerWithKeyCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConsumerWithKeyCollisionHandler.h"
#import "Collision.h"
#import "ConsumerComponent.h"
#import "KeyComponent.h"
#import "LevelSession.h"
#import "PollenComponent.h"

@implementation ConsumerWithKeyCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[ConsumerComponent class]];
		[_secondComponentClasses addObject:[KeyComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *keyEntity = secondEntity;
	[_levelSession consumedKeyEntity:keyEntity];
	return TRUE;
}

@end
