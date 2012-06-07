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
		_componentClass = componentClass;
		_componentsByEntity = [[entityManager componentsByClass] objectForKey:componentClass];
	}
	return self;
}

-(id) getComponentFor:(Entity *)entity
{
	return [_componentsByEntity objectForKey:[entity entityId]];
}

@end
