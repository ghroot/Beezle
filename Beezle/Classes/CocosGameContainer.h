//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "slick.h"

@class ForwardLayer;
@class Touch;

@interface CocosGameContainer : GameContainer
{
	ForwardLayer *_layer;
}

@property (nonatomic, readonly) ForwardLayer *layer;

-(void) intervalUpdate:(NSNumber *)delta;
-(void) intervalDraw;
-(void) touchBegan:(Touch *)touch;
-(void) touchMoved:(Touch *)touch;
-(void) touchEnded:(Touch *)touch;

@end
