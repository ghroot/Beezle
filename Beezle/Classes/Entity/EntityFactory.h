//
//  EntityFactory.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"
#import "BeeType.h"
#import "EntityDescription.h"
#import "LevelLayoutEntry.h"
#import "SortOrders.h"

@interface EntityFactory : NSObject

+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name;
+(Entity *) createEdge:(World *)world;

+(Entity *) createEntity:(NSString *)type world:(World *)world;

+(Entity *) createBee:(World *)world withBeeType:(BeeType *)beeType andVelocity:(CGPoint)velocity;
+(Entity *) createAimPollen:(World *)world withVelocity:(CGPoint)velocity;
+(Entity *) createMovementIndicator:(World *)world forEntity:(Entity *)entity;

@end
