//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "RespawnInfo.h"

static const int RESPAWN_DURATION = 50;

@implementation RespawnInfo

@synthesize entityType = _entityType;
@synthesize position = _position;

-(id) initWithEntityType:(NSString *)entityType position:(CGPoint)position respawnAnimationName:(NSString *)respawnAnimationName
{
	if (self = [super init])
	{
		_entityType = [entityType copy];
		_position = position;
		_respawnAnimationName = [respawnAnimationName copy];
		_countdown = RESPAWN_DURATION;
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];
	[_respawnAnimationName release];

	[super dealloc];
}


-(BOOL) hasCountdownReachedZero
{
	return _countdown <= 0;
}

-(void) decreaseCountdown
{
	_countdown--;
}

@end
