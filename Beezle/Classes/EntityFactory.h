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

@interface EntityFactory : NSObject

+(RenderComponent *) createRenderComponent:(World *) withFile:(NSString *)fileName;

+(Entity *) createBackground:(World *)world withFileName:(NSString *)fileName;
+(Entity *) createEdge:(World *)world  withSize:(CGSize)size;
+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position;
+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity;
+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation;
+(Entity *) createPollen:(World *)world withPosition:(CGPoint)position;

@end
