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

-(void) setup
{
    [super setup];
    
    [_layer setTarget:self];
    [_layer setTouchBeganSelector:@selector(touchBegan:)];
    [_layer setTouchMovedSelector:@selector(touchMoved:)];
    [_layer setTouchEndedSelector:@selector(touchEnded:)];
}

-(void) startInterval
{
    [_layer setUpdateSelector:@selector(intervalUpdate:)];
    [_layer setDrawSelector:@selector(intervalDraw)];
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

-(void) touchBegan:(Touch *)touch
{
    [_game touchBegan:touch];
}

-(void) touchMoved:(Touch *)touch
{
    [_game touchMoved:touch];
}

-(void) touchEnded:(Touch *)touch
{
    [_game touchEnded:touch];
}

@end
