//
//  TransformBehaviour.h
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@interface TransformComponent : Component
{
    CGPoint _position;
    float _rotation;
    CGPoint _scale;
}

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;
@property (nonatomic) CGPoint scale;

-(id) initWithPosition:(CGPoint)position;

@end
