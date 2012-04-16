//
//  WoodComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface WoodComponent : Component
{
	int _shapeIndexAtCollision;
}

@property (nonatomic) int shapeIndexAtCollision;

@end
