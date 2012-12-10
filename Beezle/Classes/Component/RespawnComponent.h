//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "artemis.h"

/**
  Entity is re-created shortly after being destroyed.
 */
@interface RespawnComponent : Component
{
	// Type
	NSString *_entityType;
	NSString *_respawnAnimationName;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) NSString *respawnAnimationName;

@end
