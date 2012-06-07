//
// Created by marcus on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ComponentType.h"

static int nextId = 0;

@implementation ComponentType

@synthesize id = _id;

-(id) init
{
	if (self = [super init])
	{
		_id = nextId++;
	}
	return self;
}

@end
