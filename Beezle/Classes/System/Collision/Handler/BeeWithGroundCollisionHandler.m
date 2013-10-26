//
// Created by Marcus on 2013-10-21.
//

#import "BeeWithGroundCollisionHandler.h"
#import "BeeComponent.h"
#import "GroundComponent.h"
#import "SoundManager.h"

@implementation BeeWithGroundCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BeeComponent class]];
		[_secondComponentClasses addObject:[GroundComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *beeEntity = firstEntity;
	Entity *groundEntity = secondEntity;

	BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
	GroundComponent *groundComponent = [GroundComponent getFrom:groundEntity];
	if ([beeComponent type] == [BeeType BURNEE] &&
			[groundComponent isIce])
	{
		[[SoundManager sharedManager] playSound:@"BurneeSteam"];
	}

	return TRUE;
}

@end
