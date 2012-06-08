//
// Created by marcus on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class Entity;
@class EntityManager;

@interface ComponentMapper : NSObject
{
	NSMutableDictionary *_componentsByEntity;
}

-(id) initWithEntityManager:(EntityManager *)entityManager componentClass:(Class)componentClass;

-(id) getComponentFor:(Entity *)entity;
-(BOOL) hasEntityComponent:(Entity *)entity;

@end
