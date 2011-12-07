//
//  CocosGameState.m
//  Beezle
//
//  Created by Me on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameState.h"
#import "CocosGameContainer.h"
#import "ForwardLayer.h"

@implementation CocosGameState

@synthesize scene = _scene;
@synthesize layer = _layer;

-(id) initWithId:(int)stateId
{
    if (self = [super initWithId:stateId])
    {
        _scene = [[CCScene alloc] init];
        _layer = [[ForwardLayer alloc] init];
        [_scene addChild:_layer];
    }
    return self;
}

-(void) dealloc
{
    [_scene release];
    [_layer release];
    
    [super dealloc];
}

@end
