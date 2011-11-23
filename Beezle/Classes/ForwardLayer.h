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
    id _target;
    SEL _updateSelector;
    SEL _drawSelector;
    SEL _touchBeganSelector;
    SEL _touchMovedSelector;
    SEL _touchEndedSelector;
}

-(void) setTarget:(id)target;
-(void) setUpdateSelector:(SEL)selector;
-(void) setDrawSelector:(SEL)selector;
-(void) setTouchBeganSelector:(SEL)selector;
-(void) setTouchMovedSelector:(SEL)selector;
-(void) setTouchEndedSelector:(SEL)selector;

@end
