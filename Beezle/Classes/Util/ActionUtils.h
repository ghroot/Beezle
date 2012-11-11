//
// Created by Marcus on 10/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class CCSprite;

@interface ActionUtils : NSObject

+(void) swaySprite:(CCSprite *)sprite speed:(float)speed distance:(float)distance;
+(void) animateSprite:(CCSprite *)sprite fileNames:(NSArray *)fileNames delay:(float)delay;

@end
