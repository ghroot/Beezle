//
//  InputAction.h
//  Beezle
//
//  Created by Me on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchTypes.h"

@interface InputAction : NSObject
{
    TouchType _touchType;
    CGPoint _touchLocation;
}

@property (nonatomic, readonly) TouchType touchType;
@property (nonatomic, readonly) CGPoint touchLocation;

-(id) initWithTouchType:(TouchType)touchType andTouchLocation:(CGPoint)touchLocation;

@end
