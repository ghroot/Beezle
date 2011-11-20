//
//  EntityFactory.h
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface EntityFactory : NSObject

+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position;
+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity;
+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation;

@end
