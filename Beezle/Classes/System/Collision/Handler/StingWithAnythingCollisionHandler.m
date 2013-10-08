//
// Created by Marcus on 2013-10-08.
//

#import "StingWithAnythingCollisionHandler.h"
#import "StingComponent.h"
#import "EntityUtil.h"

@implementation StingWithAnythingCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[StingComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *stingEntity = firstEntity;

	[EntityUtil destroyEntity:stingEntity];

	return TRUE;
}

@end
