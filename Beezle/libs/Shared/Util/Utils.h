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

+(cpVect) createVectorWithRandomAngleAndLengthBetween:(int)minLength and:(int)maxLength;
+(float) unwindAngleDegrees:(float)angle;
+(float) unwindAngleRadians:(float)angle;
+(CGPoint) getScreenCenterPosition;

@end
