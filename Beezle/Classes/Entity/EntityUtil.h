//
//  EntityUtil.h
//  Beezle
//
//  Created by Me on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface EntityUtil : NSObject

+(void) setEntityPosition:(Entity *)entity position:(CGPoint)position;
+(void) setEntityRotation:(Entity *)entity rotation:(float)rotation;
+(void) setEntityMirrored:(Entity *)entity mirrored:(BOOL)mirrored;
+(void) animateAndDeleteEntity:(Entity *)entity animationName:(NSString *)animationName disablePhysics:(BOOL)disablePhysics;
+(void) fadeOutAndDeleteEntity:(Entity *)entity duration:(float)duration;

@end
