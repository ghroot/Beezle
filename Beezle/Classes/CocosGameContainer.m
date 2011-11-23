//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameContainer.h"
#import "ForwardLayer.h"

@implementation CocosGameContainer

@synthesize layer = _layer;

-(id) initWithGame:(Game *)game
{
	if (self = [super initWithGame:game])
	{
		_layer = [[ForwardLayer alloc] init];
	}
	return self;
}

-(void) startInterval
{
    [_layer setUpdateTarget:self withSelector:@selector(intervalUpdate:)];
    [_layer setDrawTarget:self withSelector:@selector(intervalDraw)];
    [_layer scheduleUpdate];
}

-(void) intervalUpdate:(NSNumber *)delta
{
    [self update:[delta floatValue]];
}

-(void) intervalDraw
{
    [self render];
}

@end
