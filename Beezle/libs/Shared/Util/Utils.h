//
//  Utils.h
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"
#import "cocos2d.h"

@interface Utils : NSObject

+(cpVect) createVectorWithRandomAngleAndLengthBetween:(float)minLength and:(float)maxLength;
+(float) unwindAngleDegrees:(float)angle;
+(float) unwindAngleRadians:(float)angle;
+(float) cocos2dDegreesToChipmunkDegrees:(float)cocos2dDegrees;
+(float) cocos2dDegreesToChipmunkRadians:(float)cocos2dDegrees;
+(float) chipmunkDegreesToCocos2dDegrees:(float)chipmunkDegrees;
+(float) chipmunkRadiansToCocos2dDegrees:(float)chipmunkRadians;
+(CGPoint) getScreenCenterPosition;

@end
