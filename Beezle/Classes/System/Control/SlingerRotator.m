//
// Created by Marcus on 10/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SlingerRotator.h"
#import "EntityUtil.h"

@implementation SlingerRotator

-(id) initWithSlingerEntity:(Entity *)slingerEntity
{
	if (self = [super init])
	{
		_slingerEntity = [slingerEntity retain];
	}
	return self;
}

-(void) dealloc
{
	[_slingerEntity release];

	[super dealloc];
}


-(float) rotation
{
	return _rotation;
}

-(void) setRotation:(float)rotation
{
	_rotation = rotation;

	[EntityUtil setEntityRotation:_slingerEntity rotation:_rotation];
}

@end
