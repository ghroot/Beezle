//
// Created by Marcus on 2013-10-21.
//

#import "StingerWithPollenCollisionHandler.h"
#import "StingerComponent.h"
#import "PollenComponent.h"
#import "EntityUtil.h"

@implementation StingerWithPollenCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[StingerComponent class]];
		[_secondComponentClasses addObject:[PollenComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *pollenEntity = secondEntity;

	[EntityUtil destroyEntity:pollenEntity];

	return FALSE;
}

@end