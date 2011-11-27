//
//  CocosGameState.m
//  Beezle
//
//  Created by Me on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameState.h"
#import "CocosGameContainer.h"

@implementation CocosGameState

-(id) initWithId:(int)stateId
{
    if (self = [super initWithId:stateId])
    {
        _scene = [[CCScene alloc] init];
        _layer = [[CCLayer alloc] init];
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

-(void) enter
{
    CocosGameContainer *cocosGameContainer = (CocosGameContainer *)[_game container];
    [cocosGameContainer setScene:_scene];
}

@end
