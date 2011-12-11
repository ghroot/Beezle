//
//  EntityFactory.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"
#import "BeeTypes.h"

@interface EntityFactory : NSObject

+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name;
+(Entity *) createEdge:(World *)world;
+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position beeTypes:(NSArray *)beeTypes;
+(Entity *) createBee:(World *)world type:(BeeType)type withPosition:(CGPoint)position andVelocity:(CGPoint)velocity;
+(Entity *) createBeeater:(World *)world withPosition:(CGPoint)position mirrored:(BOOL)mirrored beeType:(BeeType)beeType;
+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation;
+(Entity *) createPollen:(World *)world withPosition:(CGPoint)position;
+(Entity *) createMushroom:(World *)world withPosition:(CGPoint)position;
+(Entity *) createWood:(World *)world withPosition:(CGPoint)position;
+(Entity *) createNut:(World *)world withPosition:(CGPoint)position;
+(Entity *) createAimPollen:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity;

@end
