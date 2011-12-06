//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "slick.h"

@class ForwardNode;
@class Touch;

@interface CocosGameContainer : GameContainer
{
    ForwardNode *_forwardNode;
}

-(void) setScene:(CCScene *)scene keepCurrent:(BOOL)keepCurrent;
-(void) gotoPreviousScene;

-(void) onUpdate:(NSNumber *)delta;
-(void) onDraw;
-(void) onTouchBegan:(Touch *)touch;
-(void) onTouchMoved:(Touch *)touch;
-(void) onTouchEnded:(Touch *)touch;

@end
