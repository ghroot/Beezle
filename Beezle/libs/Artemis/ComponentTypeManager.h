//
// Created by marcus on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class ComponentType;

@interface ComponentTypeManager : NSObject
{
	NSMutableDictionary *_componentTypes;
}

+(ComponentTypeManager *) sharedManager;

-(ComponentType *) getTypeFor:(Class)componentClass;
-(int) getId:(Class)componentClass;

@end
