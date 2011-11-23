//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameContainer.h"

@implementation CocosGameContainer

@synthesize layer = _layer;

-(id) init
{
	if (self = [super init])
	{
		_layer = [CCLayer node];
	}
	return self;
}

@end
