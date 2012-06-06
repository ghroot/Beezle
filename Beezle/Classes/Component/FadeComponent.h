//
//  FadeComponent
//  Beezle
//
//  Created by marcus on 06/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringCollection;

@interface FadeComponent : Component
{
	// Type
	float _duration;
	StringCollection *_animationNames;

	// Transient
	float _countdown;
	NSString *_currentAnimationName;
}

@property (nonatomic, copy) NSString *currentAnimationName;

-(void) resetCountdown;
-(void) decreaseCountdown:(float)delta;
-(BOOL) hasCountdownReachedZero;
-(NSString *) targetAnimationName;

@end