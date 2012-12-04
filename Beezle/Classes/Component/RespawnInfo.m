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

-(id) initWithEntityType:(NSString *)entityType andPosition:(CGPoint)position
{
	if (self = [super init])
	{
		_entityType = [entityType copy];
		_position = position;
		_countdown = RESPAWN_DURATION;
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];

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
