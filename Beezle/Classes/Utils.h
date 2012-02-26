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

+(CGPoint) stringToPoint:(NSString *)string;
+(NSString *) pointToString:(CGPoint)point;
+(CGSize) stringToSize:(NSString *)string;
+(NSString *) sizeToString:(CGSize)size;
+(cpVect) createVectorWithRandomAngleAndLengthBetween:(int)minLength and:(int)maxLength;
+(float) unwindAngleDegrees:(float)angle;
+(float) unwindAngleRadians:(float)angle;

@end
