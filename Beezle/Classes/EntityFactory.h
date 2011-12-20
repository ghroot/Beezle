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
+(Entity *) createSlinger:(World *)world withBeeTypes:(NSArray *)beeTypes;
+(Entity *) createBee:(World *)world withBeeType:(BeeTypes *)type andVelocity:(CGPoint)velocity;
+(Entity *) createBeeater:(World *)world withBeeType:(BeeTypes *)beeType;
+(Entity *) createRamp:(World *)world;
+(Entity *) createPollen:(World *)world;
+(Entity *) createMushroom:(World *)world;
+(Entity *) createWood:(World *)world;
+(Entity *) createNut:(World *)world;
+(Entity *) createAimPollen:(World *)world withVelocity:(CGPoint)velocity;

@end
