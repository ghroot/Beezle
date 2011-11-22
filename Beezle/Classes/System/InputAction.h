//
//  InputAction.h
//  Beezle
//
//  Created by Me on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum
{
    TOUCH_NONE,
    TOUCH_START,
    TOUCH_MOVE,
    TOUCH_END,
} touchTypes;

@interface InputAction : NSObject
{
    int _touchType;
    CGPoint _touchLocation;
}

@property (nonatomic, readonly) int touchType;
@property (nonatomic, readonly) CGPoint touchLocation;

-(id) initWithTouchType:(int)touchType andTouchLocation:(CGPoint)touchLocation;

@end
