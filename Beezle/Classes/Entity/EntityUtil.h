//
//  EntityUtil.h
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "ObjectiveChipmunk.h"

@interface EntityUtil : NSObject

+(void) setEntityPosition:(Entity *)entity position:(CGPoint)position;
+(void) setEntityRotation:(Entity *)entity rotation:(float)rotation;
+(void) setEntityMirrored:(Entity *)entity mirrored:(BOOL)mirrored;
+(void) disableAllComponents:(Entity *)entity;
+(void) enableAllComponents:(Entity *)entity;
+(BOOL) isEntityDisposable:(Entity *)entity;
+(BOOL) isEntityDisposed:(Entity *)entity;
+(void) setEntityDisposed:(Entity *)entity sendNotification:(BOOL)sendNotification;
+(void) setEntityDisposed:(Entity *)entity;
+(void) setEntityIsAboutToBeDeleted:(Entity *)entity;
+(void) destroyEntity:(Entity *)entity instant:(BOOL)instant;
+(void) destroyEntity:(Entity *)entity;
+(void) disablePhysics:(Entity *)entity;
+(Entity *) getWaterEntity:(World *)world;
+(BOOL) hasWaterEntity:(World *)world;
+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName disablePhysics:(BOOL)disablePhysics;
+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName;
+(void) animateAndDeleteEntity:(Entity *)entity disablePhysics:(BOOL)disablePhysics;
+(void) animateAndDeleteEntity:(Entity *)entity;
+(void) fadeOutAndDeleteEntity:(Entity *)entity duration:(float)duration;
+(void) playDefaultCollisionSound:(Entity *)entity;
+(void) playDefaultDestroySound:(Entity *)entity;
+(CGPoint) getRandomPositionWithinShapes:(NSArray *)shapes boundingBox:(cpBB)boundingBox;

@end
