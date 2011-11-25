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
    [_layer setTouchBeganSelector:@selector(onTouchBegan:)];
    [_layer setTouchMovedSelector:@selector(onTouchMoved:)];
    [_layer setTouchEndedSelector:@selector(onTouchEnded:)];
    
    CCScene *scene = [CCScene node];
    [scene addChild:_layer];
    [[CCDirector sharedDirector] runWithScene:scene];
}

-(void) startInterval
{
    [_layer setUpdateSelector:@selector(onUpdate:)];
    [_layer setDrawSelector:@selector(onDraw)];
	
	[[CCDirector sharedDirector] setAnimationInterval:_updateInterval];
    [_layer scheduleUpdate];
}

-(void) onUpdate:(NSNumber *)delta
{
    [self update:[delta intValue]];
}

-(void) onDraw
{
    [self render];
}

-(void) onTouchBegan:(Touch *)touch
{
    [_game touchBegan:touch];
}

-(void) onTouchMoved:(Touch *)touch
{
    [_game touchMoved:touch];
}

-(void) onTouchEnded:(Touch *)touch
{
    [_game touchEnded:touch];
}

@end
