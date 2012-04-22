//
//  SolidWithSoundCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithSoundCollisionHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "SolidComponent.h"
#import "SoundComponent.h"

#define VELOCITY_TIMES_MASS_FOR_SOUND 80.0f

@implementation SolidWithSoundCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[SoundComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	if ([collision firstEntityVelocityTimesMass] >= VELOCITY_TIMES_MASS_FOR_SOUND)
	{
		[EntityUtil playDefaultCollisionSound:secondEntity];
	}
	
	return TRUE;
}

@end
