//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "slick.h"

@class Touch;

@interface CocosGameContainer : GameContainer

-(void) onUpdate:(NSNumber *)delta;
-(void) onDraw;
-(void) onTouchBegan:(Touch *)touch;
-(void) onTouchMoved:(Touch *)touch;
-(void) onTouchEnded:(Touch *)touch;

@end
