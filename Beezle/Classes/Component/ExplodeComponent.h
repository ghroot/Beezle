//
//  ExplodeComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface ExplodeComponent : Component
{
	int _radius;
	NSString *_explodeStartAnimationName;
	NSString *_explodeEndAnimationName;
}

@property (nonatomic) int radius;
@property (nonatomic, retain) NSString *explodeStartAnimationName;
@property (nonatomic, retain) NSString *explodeEndAnimationName;

@end
