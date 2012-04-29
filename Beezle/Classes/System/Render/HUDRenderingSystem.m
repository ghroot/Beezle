//
//  HUDSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HUDRenderingSystem.h"
#import "PlayerInformation.h"

@implementation HUDRenderingSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super init])
	{
		_layer = layer;
	}
	return self;
}

@end
