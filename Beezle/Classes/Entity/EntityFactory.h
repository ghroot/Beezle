//
//  EntityFactory.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class BeeType;
@class EntityDescription;

@interface EntityFactory : NSObject

+(Entity *) createEdge:(World *)world;
+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name;
+(Entity *) createWater:(World *)world withLevelName:(NSString *)levelName;

+(Entity *) createEntity:(NSString *)type world:(World *)world instanceComponentsDict:(NSDictionary *)instanceComponentsDict edit:(BOOL)edit;
+(Entity *) createEntity:(NSString *)type world:(World *)world edit:(BOOL)edit;
+(Entity *) createEntity:(NSString *)type world:(World *)world;

+(Entity *) createBee:(World *)world withBeeType:(BeeType *)beeType andVelocity:(CGPoint)velocity;
+(Entity *) createAimPollen:(World *)world withBeeType:(BeeType *)beeType velocity:(CGPoint)velocity duration:(float)duration;
+(Entity *) createMovementIndicator:(World *)world forEntity:(Entity *)entity;
+(Entity *) createTeleportOutPosition:(World *)world;
+(Entity *) createSimpleAnimatedEntity:(World *)world;
+(Entity *) createSimpleAnimatedEntity:(World *)world animationFile:(NSString *)animationFile;
+(Entity *) createShardPieceEntity:(World *)world animationName:(NSString *)animationName smallAnimationNames:(NSArray *)smallAnimationNames spriteSheetName:(NSString *)spriteSheetName animationFile:(NSString *)animationFile shapeSize:(CGSize)shapeSize;
+(Entity *) createShardPieceEntity:(World *)world animationName:(NSString *)animationName smallAnimationNames:(NSArray *)smallAnimationNames spriteSheetName:(NSString *)spriteSheetName animationFile:(NSString *)animationFile;

@end
