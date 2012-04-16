//
//  WaterComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface WaterComponent : Component
{
	NSString *_waterType;
	NSString *_splashAnimationName;
}

@property (nonatomic, copy) NSString *waterType;
@property (nonatomic, copy) NSString *splashAnimationName;

@end
