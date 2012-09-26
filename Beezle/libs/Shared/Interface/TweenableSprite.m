//
//  TweenableSprite
//  Beezle
//
//  Created by marcus on 24/09/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TweenableSprite.h"

@implementation TweenableSprite

-(void) setTweenableX:(float)tweenableX
{
	[self setPosition:CGPointMake(tweenableX, [self position].y)];
}

-(void) setTweenableY:(float)tweenableY
{
	[self setPosition:CGPointMake([self position].x, tweenableY)];
}

@end
