//
// Created by Marcus on 2013-10-08.
//

#import "StingWithPollenCollisionHandler.h"
#import "StingComponent.h"
#import "PollenComponent.h"
#import "EntityUtil.h"

@implementation StingWithPollenCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[StingComponent class]];
		[_secondComponentClasses addObject:[PollenComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *pollenEntity = secondEntity;

	[EntityUtil destroyEntity:pollenEntity];

	return TRUE;
}

@end
