//
// Created by marcus on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ComponentTypeManager.h"
#import "ComponentType.h"

@implementation ComponentTypeManager

+(ComponentTypeManager *) sharedManager
{
	static ComponentTypeManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(id) init
{
	if (self = [super init])
	{
		_componentTypes = [NSMutableDictionary new];
	}
	return self;
}

-(void) dealloc
{
	[_componentTypes release];

	[super dealloc];
}

-(ComponentType *) getTypeFor:(Class)componentClass
{
	ComponentType *componentType = [_componentTypes objectForKey:componentClass];
	if (componentType == nil)
	{
		componentType = [[ComponentType new] autorelease];
		[_componentTypes setObject:componentType forKey:componentClass];
	}
	return componentType;
}

-(int) getId:(Class)componentClass
{
	return [[self getTypeFor:componentClass] id];
}

@end
