//
//  ForwardLayer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ForwardLayer : CCLayer
{
    id _updateTarget;
    SEL _updateSelector;
    id _drawTarget;
    SEL _drawSelector;
}

-(void) setUpdateTarget:(id)target withSelector:(SEL)selector;
-(void) setDrawTarget:(id)target withSelector:(SEL)selector;

@end
