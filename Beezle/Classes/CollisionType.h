//
//  CollisionType.h
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GandEnum.h"

@interface CollisionType : GandEnum

+(CollisionType *) BACKGROUND;
+(CollisionType *) EDGE;
+(CollisionType *) BEE;
+(CollisionType *) BEEATER;
+(CollisionType *) RAMP;
+(CollisionType *) POLLEN;
+(CollisionType *) MUSHROOM;
+(CollisionType *) WOOD;
+(CollisionType *) NUT;
+(CollisionType *) HANGNEST;
+(CollisionType *) AIM_POLLEN;

@end
