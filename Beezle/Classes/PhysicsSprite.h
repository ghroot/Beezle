//
//  PhysicsSprite.h
//  Beezle
//
//  Created by Me on 02/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

#import "chipmunk.h"
#import "cocos2d.h"

@interface PhysicsSprite : CCSprite
{
	cpBody *_body;	// strong ref
}

-(void) setPhysicsBody:(cpBody *)body;

@end
