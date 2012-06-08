//
// Created by marcus on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ComponentMapper.h"
#import "Entity.h"
#import "EntityManager.h"

@implementation ComponentMapper

-(id) initWithEntityManager:(EntityManager *)entityManager componentClass:(Class)componentClass
{
	if (self = [super init])
	{
		_componentsByEntity = [entityManager getComponentsByEntity:componentClass];
	}
	return self;
}

-(id) getComponentFor:(Entity *)entity
{
	return [_componentsByEntity objectForKey:[entity entityId]];
}

-(BOOL) hasEntityComponent:(Entity *)entity
{
	return [self getComponentFor:entity] != nil;
}

@end